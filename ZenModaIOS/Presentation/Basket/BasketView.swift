//
//  BasketView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 24.06.2025.
//

import SwiftUI
import Kingfisher

struct BasketView: View {
    var scrollToTopCallback: ((@escaping () -> Void) -> Void)?
    
    @StateObject private var viewModel: BasketViewModel = BasketViewModel()
    @State private var selectAll = true
    @State private var recommendedProducts: [Product] = []
    @State private var showPriceDetails = false
    @State private var showClearBasketAlert = false
    @State private var showDeleteItemAlert = false
    @State private var itemToDelete: BasketProduct?
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            contentView
        }
        .background(Color.backgroundApp)
        .overlay(priceDetailsOverlay)
        .alert("clear_basket_title".localizedString(), isPresented: $showClearBasketAlert) {
            Button("cancel".localizedString(), role: .cancel) { }
            Button("clear".localizedString(), role: .destructive) {
                viewModel.clearBasket()
            }
        } message: {
            Text("clear_basket_message".localizedString())
        }
        .alert("delete_item_title".localizedString(), isPresented: $showDeleteItemAlert) {
            Button("cancel".localizedString(), role: .cancel) { }
            Button("delete".localizedString(), role: .destructive) {
                deleteItem()
            }
        } message: {
            Text("delete_item_message".localizedString())
        }
        .onAppear {
            viewModel.loadBasketItems()
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 12) {
            titleSection
            controlsSection
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
    }
    
    private var titleSection: some View {
        HStack {
            Text("cart_title".localizedString())
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("\(viewModel.itemCount) \("items_count".localizedString())")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
    
    private var controlsSection: some View {
        HStack {
            selectAllButton
            Spacer()
            clearBasketButton
        }
    }
    
    private var selectAllButton: some View {
        Button(action: { selectAll.toggle() }) {
            HStack(spacing: 8) {
                Image(systemName: selectAll ? "checkmark.square.fill" : "square")
                    .foregroundColor(selectAll ? .blue : .gray)
                    .font(.system(size: 18))
                
                Text("select_all".localizedString())
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
            }
        }
    }
    
    @ViewBuilder
    private var clearBasketButton: some View {
        if !viewModel.basketItems.isEmpty {
            Button(action: { showClearBasketAlert = true }) {
                Text("clear_basket".localizedString())
                    .font(.system(size: 14))
                    .foregroundColor(.red)
            }
        }
    }
    
    // MARK: - Content View
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            loadingView
        } else if viewModel.basketItems.isEmpty {
            emptyStateView
        } else {
            basketContentView
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundApp)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("empty_basket".localizedString())
                .font(.title3)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundApp)
    }
    
    private var basketContentView: some View {
        VStack(spacing: 0) {
            basketScrollView
            bottomBar
        }
    }
    
    private var basketScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                Spacer()
                    .frame(height: 5)
                    .background(Color.clear)
                
                basketItemsList
                recommendedSection
            }
        }
    }
    
    private var basketItemsList: some View {
        ForEach(viewModel.basketItems) { item in
            BasketItemView(
                product: item,
                isSelected: selectAll,
                onDelete: { product in
                    itemToDelete = product
                    showDeleteItemAlert = true
                },
                onQuantityChange: { quantity in
                    viewModel.updateQuantity(basketItemId: item.basketItemId, quantity: quantity)
                }
            )
            
            Divider()
                .background(Color.gray.opacity(0.2))
        }
    }
    
    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            recommendedSectionTitle
            recommendedProductsScroll
        }
        .padding(.top, 24)
        .padding(.bottom, 10)
    }
    
    private var recommendedSectionTitle: some View {
        HStack {
            Text("you_might_also_like".localizedString())
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.leading, 16)
            
            Spacer()
        }
    }
    
    private var recommendedProductsScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(recommendedProducts) { product in
                    ProductCardView(product: product)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Bottom Bar
    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.gray.opacity(0.3))
            
            bottomBarContent
        }
    }
    
    private var bottomBarContent: some View {
        HStack {
            priceSection
            Spacer()
            confirmButton
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
    }
    
    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("total_price".localizedString())
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 8) {
                Text(formattedTotalPrice())
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Button(action: { showPriceDetails = true }) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    private var confirmButton: some View {
        Button(action: {
            // Add your confirm action here
        }) {
            Text("confirm_cart".localizedString())
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(height: 48)
                .frame(maxWidth: 160)
                .background(Color.blue)
                .cornerRadius(8)
        }
    }
    
    // MARK: - Price Details Overlay
    @ViewBuilder
    private var priceDetailsOverlay: some View {
        if showPriceDetails {
            priceDetailsModal
        }
    }
    
    private var priceDetailsModal: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    showPriceDetails = false
                }
            
            VStack {
                Spacer()
                
                PriceDetailsModal(
                    subtotal: formattedSubtotal(),
                    delivery: "15 TMT",
                    discount: formattedDiscount(),
                    total: formattedTotalPrice(),
                    onConfirm: {
                        showPriceDetails = false
                    }
                )
                .transition(.move(edge: .bottom))
            }
        }
    }
    
    // MARK: - Helper Methods
    private func formattedTotalPrice() -> String {
        return String(format: "%.0f TMT", viewModel.totalAmount)
    }
    
    private func formattedSubtotal() -> String {
        return String(format: "%.0f TMT", viewModel.totalAmount)
    }
    
    private func formattedDiscount() -> String {
        let savings = viewModel.totalSavings
        return savings > 0 ? String(format: "-%.0f TMT", savings) : "0 TMT"
    }
    
    private func deleteItem() {
        guard let itemToDelete = itemToDelete else { return }
        viewModel.deleteItem(productId: itemToDelete.id, variation: itemToDelete.variation?.id ?? 0)
        self.itemToDelete = nil
    }
}

// MARK: - Basket Item View
struct BasketItemView: View {
    let product: BasketProduct
    let isSelected: Bool
    let onDelete: (BasketProduct) -> Void
    let onQuantityChange: (Int) -> Void
    @State private var quantity: Int
    @State private var isFavorite = false
    
    init(product: BasketProduct, isSelected: Bool, onDelete: @escaping (BasketProduct) -> Void, onQuantityChange: @escaping (Int) -> Void) {
        self.product = product
        self.isSelected = isSelected
        self.onDelete = onDelete
        self.onQuantityChange = onQuantityChange
        self._quantity = State(initialValue: product.quantity)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Store name section
            HStack {
                Text("\("seller".localizedString()): Unknown")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            .background(Color.white)
            
            // Product details container
            HStack(alignment: .center, spacing: 12) {
                // Checkbox
                Button(action: {
                    
                }) {
                    Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                        .foregroundColor(isSelected ? .blue : .gray)
                        .font(.system(size: 18))
                }
                
                // Product image
                KFImage(URL(string: product.photo ?? ""))
                    .placeholder {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray.opacity(0.5))
                            )
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .clipped()
                
                // Product info
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name.localizedValue)
                        .font(.system(size: 15))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 4) {
                        Text("\("size".localizedString()):")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        
                        Text(product.variation?.name ?? "")
                            .font(.system(size: 13))
                            .foregroundColor(.primary)
                        
                        Text("\("last".localizedString()) \(product.variation?.stock ?? 0)")
                            .font(.system(size: 13))
                            .foregroundColor(.pink)
                        
                        Text("items".localizedString())
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                            Text(product.formattedBasePrice)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                                .strikethrough()
                        
                        Text(product.formattedCurrentPrice)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .background(Color.white)
            
            // Separator line
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .padding(.horizontal, 16)
            
            // Actions row
            HStack(spacing: 20) {
                Button(action: { isFavorite.toggle() }) {
                    HStack(spacing: 4) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .gray)
                            .font(.system(size: 16))
                        
                        Text("favorite".localizedString())
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Button(action: { onDelete(product) }) {
                    HStack(spacing: 4) {
                        Image(systemName: "bag")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                        
                        Text("remove".localizedString())
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Menu {
                    ForEach(1...10, id: \.self) { num in
                        Button("\(num)") {
                            quantity = num
                            onQuantityChange(num)
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("\("quantity".localizedString()) \(quantity)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView()
    }
}
