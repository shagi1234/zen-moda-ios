import SwiftUI
import Kingfisher

struct SizeWithStock {
    let name: String
    let stock: Int
}

enum DescriptionTab {
    case description
    case details
}

struct ProductDetailView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var viewModel = ProductDetailViewModel()
    @State private var headerOpacity: CGFloat = 0
    @State private var showSizeSelector = false
    @State private var showProductQAModal = false
    @State private var productQuestionText = ""
    @State private var agreeToQATerms = false
    @State private var selectedDescriptionTab: DescriptionTab = .description
    
    
    let productId: String
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                LoadingView()
            } else if let productDetail = viewModel.productDetail {
                contentView(productDetail: productDetail)
            } else {
                EmptyStateView()
            }
        }
        .background(Color(UIColor.systemGray6))
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.loadProductDetail(productId: productId)
        }
        .alert("error".localizedString(), isPresented: $viewModel.showError) {
            Button("ok".localizedString()) { }
        } message: {
            Text(viewModel.errorMessage ?? "error_occurred".localizedString())
        }
        .alert("success".localizedString(), isPresented: $viewModel.showAddToCartSuccess) {
            Button("ok".localizedString()) { }
        } message: {
            Text("product_added_to_cart_success".localizedString())
        }
        .sheet(isPresented: $viewModel.showProductQAModal) {
            ProductQAModalWrapper(viewModel: viewModel)
        }
        .sheet(isPresented: $showSizeSelector) {
            SizeSelectorBottomSheetWrapper(
                availableSizes: getAvailableSizesForSelectedColor(),
                selectedColor: viewModel.selectedColor,
                productDetail: viewModel.productDetail,
                selectedSize: $viewModel.selectedSizeName,
                onSizeSelected: { size in
                    viewModel.selectSize(size)
                    showSizeSelector = false
                },
                onClose: {
                    showSizeSelector = false
                }
            )
        }
    }
    
    
    
    private func getAvailableSizesForSelectedColor() -> [SizeWithStock] {
        guard let productDetail = viewModel.productDetail,
              let selectedColorId = viewModel.selectedColorId else {
            return []
        }
        
        var sizesWithStock: [SizeWithStock] = []
        
        // Get sizes from variants with selected color
        let variantsWithColor = productDetail.product.variants.filter { variant in
            // Check if variant has the selected color (you might need to adjust this based on your color matching logic)
            return true // For now, showing all variants - adjust based on your color logic
        }
        
        // Group variants by size and calculate total stock
        let sizeGroups = Dictionary(grouping: variantsWithColor) { $0.size ?? "" }
        
        for (sizeName, variants) in sizeGroups {
            if !sizeName.isEmpty {
                let totalStock = variants.reduce(0) { $0 + $1.stock }
                if totalStock > 0 {
                    sizesWithStock.append(SizeWithStock(name: sizeName, stock: totalStock))
                }
            }
        }
        
        // Also check main product if it has the selected color
        if let mainSize = productDetail.product.size, productDetail.product.stock > 0 {
            // Add main product size if not already included
            if !sizesWithStock.contains(where: { $0.name == mainSize }) {
                sizesWithStock.append(SizeWithStock(name: mainSize, stock: productDetail.product.stock))
            }
        }
        
        return sizesWithStock.sorted { $0.name < $1.name }
    }
    
    private func animatedTopComponent(product: ProductDetailed) -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = size.height + minY
            let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44
            let headerHeight = safeAreaHeight + 44
            
            ZStack {
                Color.gray.opacity(0.1)
                
                ImageCarouselView(photos: viewModel.getSelectedPhotos())
            }
            .frame(width: size.width, height: max(height, 0), alignment: .top)
            .offset(y: -minY)
            .onChange(of: minY) { _ in
                let progress = -minY / (300 - headerHeight)
                let newOpacity = min(max(progress, 0), 1)
                
                withAnimation(.easeInOut(duration: 0.1)) {
                    headerOpacity = newOpacity
                }
            }
        }
        .frame(height: 300)
    }
    
    private func contentView(productDetail: ProductDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                animatedTopComponent(product: productDetail.product)
                
                productInfoView(product: productDetail.product)
                
                if !productDetail.colors.isEmpty {
                    colorSelectionView(colors: productDetail.colors)
                }
                
                sizeSelectionButton
                
                quantitySelectionView
                
                descriptionAndDetailsSection(product: productDetail.product)
                
                storeSection(store: productDetail.product.market)
                
                relatedProductsSection
                
                productQAView
                
                storeQASection
                
                reviewsSection
                
                addToCartButton
            }
        }
        .coordinateSpace(name: "SCROLL")
        .ignoresSafeArea(edges: .top)
        .overlay(
            animatedHeaderOverlay(product: productDetail.product)
        )
    }
    
    private func animatedHeaderOverlay(product: ProductDetailed) -> some View {
        VStack {
            HStack {
                Button(action: {
                    coordinator.navigateBack()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.title2)
                        .frame(width: 44, height: 44)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                Spacer()
                
                Text(product.displayName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .opacity(headerOpacity)
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.black)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: product.isInWishlist ? "heart.fill" : "heart")
                            .foregroundColor(product.isInWishlist ? .red : .gray)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .background(
                Color.white
                    .opacity(headerOpacity * 0.95)
                    .ignoresSafeArea(edges: .top)
            )
            
            Spacer()
        }
    }
    
    private func productTitleAndSaleSection(product: ProductDetailed) -> some View {
        VStack(spacing: 0) {
            HStack {
                if let discountPercentage = product.calculatedDiscountPercentage {
                    Text("-\(discountPercentage)%")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.9, green: 0.26, blue: 0.42)) // Pink/red color from design
                        .cornerRadius(6)
                }
                
                // Timer badge (if applicable)
                if product.isNew { // You can replace this condition with actual timer logic
                    Text("01:23:59")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.96, green: 0.64, blue: 0.38)) // Orange color from design
                        .cornerRadius(6)
                }
                
                Spacer()
                
                // Store type indicator
                Text("Tukeniyor") // Replace with actual store type
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 0.9, green: 0.26, blue: 0.42))
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // Brand name
            HStack {
                Text(product.brand?.name ?? "")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.blue)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            // Product title
            HStack {
                Text(product.displayName)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
        }
        .padding(.bottom,10)
        .background(Color.white)
    }
    
    private func priceSection(product: ProductDetailed) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Arzanladyş wagty:")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                
                Text("01:23:59")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 0.96, green: 0.64, blue: 0.38))
            }
            .padding(.horizontal, 16)
            
            HStack(spacing: 12) {
                if let discountPercentage = product.calculatedDiscountPercentage {
                    Text("-\(discountPercentage)%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(red: 0.9, green: 0.26, blue: 0.42))
                        .cornerRadius(4)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    // Original price (crossed out)
                    if product.hasDiscount, let originalPrice = product.formattedOriginalPrice {
                        Text(originalPrice)
                            .font(.system(size: 12))
                            .strikethrough()
                            .foregroundColor(.gray)
                    }
                    
                    // Current price
                    Text(viewModel.formatPrice(viewModel.currentPrice))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(red: 0.9, green: 0.26, blue: 0.42))
                }
                
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            HStack {
                Image(systemName: product.inStock ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(product.inStock ? .green : .red)
                    .font(.caption)
                
                Text(product.inStock ? "in_stock".localizedString() : "out_of_stock".localizedString())
                    .font(.caption)
                    .foregroundColor(product.inStock ? .green : .red)
                
                Spacer()
                
                Text("\("stock".localizedString()): \(viewModel.stockCount)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical,10)
        .background(Color.white)
        
    }
    
    private func reviewsSection(product: ProductDetailed) -> some View {
        HStack(spacing: 12) {
            // Left card - Reviews
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 2) {
                    let rating = product.rating
                    let fullStars = Int(rating)
                    let hasHalfStar = rating - Double(fullStars) >= 0.5
                    
                    ForEach(0..<fullStars, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(red: 0.96, green: 0.64, blue: 0.38))
                            .font(.system(size: 14))
                    }
                    
                    if hasHalfStar {
                        Image(systemName: "star.leadinghalf.filled")
                            .foregroundColor(Color(red: 0.96, green: 0.64, blue: 0.38))
                            .font(.system(size: 14))
                    }
                    
                    let emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0)
                    ForEach(0..<emptyStars, id: \.self) { _ in
                        Image(systemName: "star")
                            .foregroundColor(Color(red: 0.96, green: 0.64, blue: 0.38))
                            .font(.system(size: 14))
                    }
                    
                    Spacer()
                }
                
                Text("\(product.reviewCount) Teswir (\(viewModel.formatRating(product.rating)))")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.black)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity) // This makes it take 50% of available space
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            // Right card - Delivery
            VStack(alignment: .leading, spacing: 6) {
                Text("Eltip berilmeli wagty:")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
                
                Text("15.03.2025-18.03.2025")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity) // This makes it take 50% of available space
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .padding(.horizontal, 16)
        .padding(.bottom,10)
        .background(Color(UIColor.systemGray6))
    }
    
    private func productInfoView(product: ProductDetailed) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            productTitleAndSaleSection(product: product)
            
            priceSection(product: product)
            
            reviewsSection(product: product)
        }
    }
    
    private func colorSelectionView(colors: [ProductColor]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Color header
            HStack {
                Text("color".localizedString())
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                if let selectedColorId = viewModel.selectedColorId,
                   let selectedColor = colors.first(where: { $0.id == selectedColorId }) {
                    Text(selectedColor.displayName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            // Color grid - 5 per row
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                ForEach(colors.prefix(10)) { color in // Show max 10 colors
                    colorCard(for: color)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private func colorCard(for color: ProductColor) -> some View {
        let isSelected = viewModel.selectedColorId == color.id
        
        return Button(action: {
            viewModel.selectColor(color.id)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                    )
                    .frame(height: 60)
                
                // Product image from color or fallback to main product image
                AsyncImage(url: URL(string: color.photos.first?.path ?? viewModel.getSelectedPhotos().first?.path ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                } placeholder: {
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    // MARK: - Size Selection Button (Fixed with localization)
    private var sizeSelectionButton: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Size header
            HStack {
                Text("size".localizedString())
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            // Size selection button
            Button(action: {
                showSizeSelector = true
            }) {
                HStack {
                    Text(viewModel.selectedSizeName ?? "select_size".localizedString())
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(viewModel.selectedSizeName != nil ? .black : .gray)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    
    private var quantitySelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("quantity".localizedString())
                .font(.headline)
                .fontWeight(.medium)
            
            HStack {
                Button(action: {
                    viewModel.decrementQuantity()
                }) {
                    Image(systemName: "minus")
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 40)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .disabled(viewModel.quantity <= 1)
                
                Text("\(viewModel.quantity)")
                    .font(.headline)
                    .fontWeight(.medium)
                    .frame(width: 60)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    viewModel.incrementQuantity()
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                        .frame(width: 40, height: 40)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                .disabled(viewModel.quantity >= (viewModel.productDetail?.product.stock ?? 0))
                
                Spacer()
                
                if let stock = viewModel.productDetail?.product.stock {
                    Text("\("available".localizedString()): \(stock)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private func descriptionAndDetailsSection(product: ProductDetailed) -> some View {
        VStack(spacing: 0) {
            // Tab headers
            if let specifications = product.specifications, !specifications.isEmpty {
                HStack(spacing: 0) {
                    Button(action: {
                        selectedDescriptionTab = .description
                    }) {
                        VStack(spacing: 8) {
                            Text("description".localizedString())
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(selectedDescriptionTab == .description ? .black : .gray)
                            
                            Rectangle()
                                .fill(selectedDescriptionTab == .description ? Color.black : Color.clear)
                                .frame(height: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Details tab
                    Button(action: {
                        selectedDescriptionTab = .details
                    }) {
                        VStack(spacing: 8) {
                            Text("details".localizedString())
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(selectedDescriptionTab == .details ? .blue : .gray)
                            
                            Rectangle()
                                .fill(selectedDescriptionTab == .details ? Color.blue : Color.clear)
                                .frame(height: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, 16)
                .background(Color.white)
            }
            
            // Tab content
            VStack(alignment: .leading, spacing: 16) {
                if selectedDescriptionTab == .description {
                    descriptionContent(product: product)
                } else {
                    detailsContent(product: product)
                }
            }
            .padding(16)
            .background(Color.white)
        }
    }
    
    private func descriptionContent(product: ProductDetailed) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(product.displayDescription)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func detailsContent(product: ProductDetailed) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            if let specifications = product.specifications, !specifications.isEmpty {
                ForEach(specifications, id: \.label) { specification in
                    detailRow(label: specification.label, value: specification.value)
                }
            }
        }
    }
    
    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Spacer()
            
            DottedLine()
                .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                .frame(height: 1)
                .layoutPriority(-1)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
        }
    }
    
    // MARK: - Store Section
    private func storeSection(store: Market) -> some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: store.photo ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "storefront")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                        )
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("seller".localizedString())
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Text(store.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button(action: {
                    // Navigate to store
                }) {
                    Text("visit_store".localizedString())
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(16)
            .background(Color.white)
        }
        .background(Color.clear)
    }
    
    private var addToCartButton: some View {
        VStack(spacing: 12) {
            if viewModel.quantity > 1 {
                HStack {
                    Text("total".localizedString())
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(String(format: "%.2f TMT", viewModel.totalPrice))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 20)
            }
            
            Button(action: {
                viewModel.addToCart()
            }) {
                HStack {
                    if viewModel.isAddingToCart {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    
                    Text(viewModel.isAddingToCart ? "adding".localizedString() : "add_to_cart".localizedString())
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(viewModel.canAddToCart && !viewModel.isAddingToCart ? Color.blue : Color.gray)
                .cornerRadius(12)
            }
            .disabled(!viewModel.canAddToCart || viewModel.isAddingToCart)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 20)
        .background(Color.white)
    }
    
    private var storeQASection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("store_qa".localizedString())
                .font(.headline)
                .fontWeight(.medium)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("store_qa_description".localizedString())
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Button(action: {
                    viewModel.openProductQAModal()
                }) {
                    Text("ask_question".localizedString())
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
            }
            .padding(.vertical, 20)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("reviews".localizedString())
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button(action: {
                    coordinator.navigateTo(page: .reviewsAll(productId))
                }) {
                    Text("\("view_all".localizedString()) (\(viewModel.productDetail?.product.reviewCount ?? 0))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
        }
        .background(Color.white)
    }
    
    private var productQAView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("product_qa".localizedString())
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("view_all".localizedString())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .onTapGesture {
                    coordinator.navigateTo(page: .productQuestionsAll(productId))
                }
                
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.productQuestions, id: \.id) { qaItem in
                            QuestionCard(qaItem: qaItem)
                        }
                    }
                    .padding(.horizontal, 16)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
    }
    
    private var relatedProductsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("related_products".localizedString())
                .font(.headline)
                .fontWeight(.medium)
                .padding(.horizontal, 20)
            
            
            
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(Color.white)
        
    }
}

struct ImageCarouselView: View {
    let photos: [Photo]
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            if photos.isEmpty {
                Image(systemName: "photo")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
            } else {
                TabView(selection: $currentIndex) {
                    ForEach(Array(photos.enumerated()), id: \.offset) { index, photo in
                        KFImage(URL(string: photo.path))
                            .placeholder {
                                ProgressView()
                                    .frame(width: 40, height: 40)
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                if photos.count > 1 {
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 8) {
                            ForEach(0..<photos.count, id: \.self) { index in
                                Circle()
                                    .fill(currentIndex == index ? Color.blue : Color.white.opacity(0.7))
                                    .frame(width: 8, height: 8)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("loading".localizedString())
                .font(.headline)
                .padding(.top)
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("product_not_found".localizedString())
                .font(.headline)
                .padding(.top)
        }
    }
}

extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct DottedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}


struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(productId: "1")
    }
}
