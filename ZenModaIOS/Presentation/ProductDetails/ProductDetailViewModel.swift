//
//  ProductDetailViewModel.swift
//  ZenModaIOS
//
//  Created by Shahruh on 15.07.2025.
//

import SwiftUI
import Combine

class ProductDetailViewModel: ObservableObject {
    // MARK: - Dependencies
    private let productRepository: ProductRepository
    private let cardRepository: CardRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Published Properties
    @Published var productDetailResponse: ProductDetailResponse?
    @Published var productDetail: ProductDetail?
    @Published var productQuestions: [ProductQuestionResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    // MARK: - UI State
    @Published var selectedColorId: String?
    @Published var selectedSizeName: String?
    @Published var selectedVariantId: String?
    @Published var quantity: Int = 1
    @Published var isAddingToCart = false
    @Published var showAddToCartSuccess = false
    
    @Published var showProductQAModal = false
    @Published var productQuestionText = ""
    @Published var agreeToQATerms = false
    @Published var isSubmittingQuestion = false
    
    // MARK: - Computed Properties
    var selectedColor: ProductColor? {
        guard let selectedColorId = selectedColorId else { return nil }
        return productDetail?.colors.first { $0.id == selectedColorId }
    }
    
    var selectedSize: ProductSize? {
        guard let selectedSizeName = selectedSizeName else { return nil }
        return productDetail?.sizes.first { $0.name == selectedSizeName }
    }
    
    var selectedVariant: ProductVariant? {
        guard let selectedVariantId = selectedVariantId else { return nil }
        return productDetailResponse?.product.variants.first { $0.id == selectedVariantId }
    }
    
    var availableColors: [ProductColor] {
        return productDetail?.colors.filter { $0.isAvailable } ?? []
    }
    
    var availableSizes: [ProductSize] {
        return productDetail?.sizes.filter { $0.isAvailable(in: productDetail?.product) } ?? []
    }
    
    var availableVariants: [ProductVariant] {
        return productDetailResponse?.product.availableVariants ?? []
    }
    
    var canAddToCart: Bool {
        guard let product = productDetailResponse?.product else { return false }
        
        let currentStock: Int
        if let selectedVariant = selectedVariant {
            currentStock = selectedVariant.stock
        } else {
            currentStock = product.stock
        }
        
        guard currentStock > 0 && quantity > 0 && quantity <= currentStock else { return false }
        
        if product.hasVariants && !availableVariants.isEmpty && selectedVariantId == nil {
            return false
        }
        
        let hasColors = !availableColors.isEmpty
        let hasSizes = !availableSizes.isEmpty
        
        if hasColors && selectedColorId == nil { return false }
        if hasSizes && selectedSizeName == nil { return false }
        
        return product.inStock
    }
    
    var currentPrice: Double {
        if let selectedVariant = selectedVariant {
            return selectedVariant.currentPrice
        }
        
        guard let product = productDetailResponse?.product else { return 0 }
        return product.discountPrice ?? product.basePrice
    }
    
    var totalPrice: Double {
        return currentPrice * Double(quantity)
    }
    
    var maxStock: Int {
        if let selectedVariant = selectedVariant {
            return selectedVariant.stock
        }
        return productDetailResponse?.product.stock ?? 0
    }
    
    init(productRepository: ProductRepository = ProductsRepositoryImpl(),
         cardRepository: CardRepository = CardRepositoryImpl()) {
        self.productRepository = productRepository
        self.cardRepository = cardRepository
    }
    
    func loadProductDetail(productId: String) {
        isLoading = true
        errorMessage = nil
        
        productRepository.getProductDetail(id: productId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] productDetailResponse in
                    self?.productDetailResponse = productDetailResponse
                    self?.productDetail = productDetailResponse.toProductDetail()
                    self?.setupInitialSelections()
                    
                    self?.loadReviews(productId)
                    self?.loadProductQuestions(productId)
                }
            )
            .store(in: &cancellables)
    }
    
    func loadReviews(_ productId: String) {
        let request = RequestGetProductReviews(
            page: 0, limit: 10, sort: "desc"
        )
        
        productRepository.getProductReviews(productId: productId,request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    
                }
            )
            .store(in: &cancellables)
    }
    
    func loadProductQuestions(_ productId: String) {
        let request = RequestGetProductQuestion(
            page: 0, size: 10,sort: "createdAt,desc"
        )
        
        productRepository.getProductQuestions(productId: productId,request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.productQuestions = response.data ?? []
                }
            )
            .store(in: &cancellables)
    }
    
    func addToCart() {
        guard canAddToCart,
              let productId = productDetailResponse?.product.id,
              let productIdInt = Int(productId) else {
            showErrorMessage("cannot_add_to_cart".localizedString())
            return
        }
        
        isAddingToCart = true
        
        var variationId: Int? = nil
        
        if let selectedVariantId = selectedVariantId,
           let variantIdInt = Int(selectedVariantId) {
            variationId = variantIdInt
        } else if let selectedColorId = selectedColorId,
                  let colorIdInt = Int(selectedColorId) {
            variationId = colorIdInt
        }
        
        let request = RequestAddToCard(
            product_id: productIdInt,
            variation_id: variationId,
            quantity: quantity
        )
        
        cardRepository.addToCard(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isAddingToCart = false
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.showAddToCartSuccess = true
                    self?.productDetailResponse?.product.isInCart = true
                }
            )
            .store(in: &cancellables)
    }
    
    func submitProductQuestion() {
        guard !productQuestionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              agreeToQATerms,
              let productId = productDetailResponse?.product.id,
              let productIdInt = Int(productId) else {
            showErrorMessage("please_fill_required_fields".localizedString())
            return
        }
        
        isSubmittingQuestion = true
        
        let request = RequestCreateProductQuestion(
            content: productQuestionText
        )
        
        productRepository.createProductQuestion(productId: productId,request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isSubmittingQuestion = false
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.resetProductQAForm()
                    self?.showSuccessMessage("question_submitted_success".localizedString())
                }
            )
            .store(in: &cancellables)
    }
    
    func resetProductQAForm() {
        productQuestionText = ""
        agreeToQATerms = false
        showProductQAModal = false
    }
    
    func openProductQAModal() {
        showProductQAModal = true
    }
    
    func selectColor(_ colorId: String) {
        selectedColorId = colorId
        selectedVariantId = nil
    }
    
    func selectSize(_ size: String) {
        selectedSizeName = size
        selectedVariantId = nil
    }
    
    func selectVariant(_ variantId: String) {
        selectedVariantId = variantId
        
        if let variant = selectedVariant, quantity > variant.stock {
            quantity = max(1, variant.stock)
        }
        
        if let variant = selectedVariant, let variantSize = variant.size {
            if let matchingSize = availableSizes.first(where: { $0.name == variantSize }) {
                selectedSizeName = matchingSize.name
            }
        }
    }
    
    func updateQuantity(_ newQuantity: Int) {
        quantity = max(1, min(newQuantity, maxStock))
    }
    
    func incrementQuantity() {
        updateQuantity(quantity + 1)
    }
    
    func decrementQuantity() {
        updateQuantity(quantity - 1)
    }
    
    private func setupInitialSelections() {
        if availableColors.count == 1 {
            selectedColorId = availableColors.first?.id
        }
        
        if availableSizes.count == 1 {
            selectedSizeName = availableSizes.first?.name
        }
        
        if availableVariants.count == 1 {
            selectedVariantId = availableVariants.first?.id
        }
        
        quantity = min(1, maxStock)
    }
    
    private func handleError(_ error: NetworkError) {
        errorMessage = error.userFriendlyMessage
        showError = true
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    private func showSuccessMessage(_ message: String) {
        // You can create a separate success alert or use the same error mechanism
        errorMessage = message
        showError = true
    }
    
    // MARK: - Formatting Methods
    func formatPrice(_ price: Double?) -> String {
        guard let price = price else { return "0 TMT" }
        return String(format: "%.2f TMT", price)
    }
    
    func formatPrice(_ priceString: String?) -> String {
        guard let priceString = priceString, let price = Double(priceString) else { return "0 TMT" }
        return String(format: "%.2f TMT", price)
    }
    
    func formatRating(_ rating: Double?) -> String {
        guard let rating = rating else { return "0.0" }
        return String(format: "%.1f", rating)
    }
    
    func getSelectedPhotos() -> [Photo] {
        
        if let selectedVariant = selectedVariant, !selectedVariant.photos.isEmpty {
            return selectedVariant.photos
        }
        
        if let selectedColor = selectedColor, !selectedColor.photos.isEmpty {
            return selectedColor.photos
        }
        
        return productDetailResponse?.product.photos ?? []
    }
    
    var productName: String {
        return productDetailResponse?.product.displayName ?? ""
    }
    
    var productDescription: String {
        return productDetailResponse?.product.displayDescription ?? ""
    }
    
    var isProductInStock: Bool {
        return productDetailResponse?.product.inStock ?? false
    }
    
    var stockCount: Int {
        return maxStock
    }
    
    var hasVariants: Bool {
        return productDetailResponse?.product.hasVariants ?? false
    }
    
    var isVariantProduct: Bool {
        return productDetailResponse?.isVariant ?? false
    }
}
