//
//  ProductStore.swift
//  ZenModaIOS
//
//  Created by Shahruh on 15.07.2025.
//
import Foundation

struct ProductDetailResponse: Codable {
    var product: ProductDetailed
    let productType: String
    let isVariant: Bool
    let hasVariants: Bool
}

struct ProductSpecification: Codable {
    let label: String
    let value: String
}

struct ProductQuestionResponse: Codable,Equatable {
    let id: Int
    let question: String
    let username: String
    let createdAt: String
    let answer: String
    let store: Market
}

struct ProductQuestionRequest: Codable {
    let content: String
}

struct ProductDetailed: Codable, Identifiable {
    let id: String
    let sku: String
    let name: LocalizedString
    let description: LocalizedString
    let basePrice: Double
    let discountPrice: Double?
    let discountPercentage: Int?
    let currency: String
    let size: String?
    let stock: Int
    let rating: Double
    let viewCount: Int
    let isNew: Bool
    let isFeatured: Bool
    let isRecommended: Bool
    let isInWishlist: Bool
    let isInComparison: Bool
    var isInCart: Bool
    let inStock: Bool
    let productType: String
    let isVariant: Bool
    let hasVariants: Bool
    let parentProductId: String?
    let variantCount: Int?
    let mainImage: ProductImage?
    let photos: [Photo]
    let market: Market
    let category: Category?
    let brand: Brand?
    let catalog: Catalog
    let color: ProductColor?
    let sizes: [ProductSize]
    let variants: [ProductVariant]
    let specifications: [ProductSpecification]?
    
    // Computed properties for convenience
    var displayName: String {
        return name.localizedValue
    }
    
    var displayDescription: String {
        return description.localizedValue
    }
    
    var hasDiscount: Bool {
        guard let discountPrice = discountPrice else { return false }
        return discountPrice < basePrice
    }
    
    var formattedCurrentPrice: String {
        let price = discountPrice ?? basePrice
        return String(format: "%.2f %@", price, currency)
    }
    
    var formattedOriginalPrice: String? {
        guard hasDiscount else { return nil }
        return String(format: "%.2f %@", basePrice, currency)
    }
    
    var calculatedDiscountPercentage: Int? {
        return discountPercentage
    }
    
    var imageUrl: String? {
        return mainImage?.path ?? photos.first?.path
    }
    
    var availableVariants: [ProductVariant] {
        return variants.filter { $0.stock > 0 }
    }
    
    var uniqueSizes: [String] {
        let allSizes = Set([size].compactMap { $0 } + variants.compactMap { $0.size })
        return Array(allSizes).sorted()
    }
    
    var uniqueColors: [ProductColor] {
        var colors: [ProductColor] = []
        if let currentColor = color {
            colors.append(currentColor)
        }
        // Add colors from variants if needed
        return colors
    }
}

struct ProductVariant: Codable, Identifiable {
    let id: String
    let sku: String
    let name: LocalizedString
    let basePrice: Double
    let discountPrice: Double?
    let stock: Int
    let size: String?
    let productType: String
    let isVariant: Bool
    let parentProductId: String
    let photos: [Photo]
    
    var displayName: String {
        return name.localizedValue
    }
    
    var hasDiscount: Bool {
        guard let discountPrice = discountPrice else { return false }
        return discountPrice < basePrice
    }
    
    var currentPrice: Double {
        return discountPrice ?? basePrice
    }
    
    var imageUrl: String? {
        return photos.first?.path
    }
}

struct ProductImage: Codable, Identifiable {
    let id: String
    let path: String
    
    var url: String {
        return path
    }
}

struct Market: Codable,Equatable,Identifiable {
    let id: String
    let name: String
    let photo: String?
}

struct ProductColor: Codable, Identifiable {
    let id: String
    let name: LocalizedString
    let colorCode: String
    
    var displayName: String {
        return name.localizedValue
    }
    
    var code: String {
        return colorCode
    }
    
    var isAvailable: Bool {
        return true
    }
    
    var photos: [Photo] {
        return []
    }
}

struct ProductSize: Codable, Identifiable {
    let name: String
    
    var id: String {
        return name
    }
    
    init(name: String) {
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct ProductDetail: Codable {
    let product: ProductDetailed
    let colors: [ProductColor]
    let sizes: [ProductSize]
    
    init(from response: ProductDetailResponse) {
        self.product = response.product
        
        var allColors: [ProductColor] = []
        if let mainColor = response.product.color {
            allColors.append(mainColor)
        }
        self.colors = allColors
        
        var allSizes: [ProductSize] = []
        let uniqueSizeNames = response.product.uniqueSizes
        for sizeName in uniqueSizeNames {
            allSizes.append(ProductSize(name: sizeName))
        }
        self.sizes = allSizes
    }
}

extension ProductSize {
    func isAvailable(in product: ProductDetailed?) -> Bool {
        // Check if the main product has this size and is in stock
        if product?.size == self.name && product?.stock ?? 0 > 0 {
            return true
        }
        
        // Check if any variant with this size has stock
        return ((product?.variants.contains { variant in
            variant.size == self.name && variant.stock > 0
        }) != nil)
    }
}

extension Array where Element == ProductSize {
    func availableSizes(for product: ProductDetailed) -> [ProductSize] {
        return self.filter { $0.isAvailable(in: product) }
    }
}

// MARK: - Extensions for backward compatibility
extension ProductDetailed {
    // For compatibility with existing ProductDetailView
    var store: Market? {
        return market
    }
    
    var reviewCount: Int {
        return 0 // Not provided in API response, default to 0
    }
    
    var isInStock: Bool {
        return inStock && stock > 0
    }
}

extension ProductDetailResponse {
    func toProductDetail() -> ProductDetail {
        return ProductDetail(from: self)
    }
}
