//
//  BasketProduct.swift
//  ZenModaIOS
//
//  Created by Shahruh on 17.07.2025.
//


import Foundation

struct BasketResponse: Codable {
    let success: Bool
    let message: String
    let data: [BasketProduct]
}

struct BasketProduct: Codable, Equatable, Identifiable {
    let id: String
    let name: LocalizedString
    let description: LocalizedString?
    let basePrice: String
    let discountPrice: String?
    let quantity: Int
    let basketItemId: String
    let variation: ProductVariation?
    let currentPrice: String
    let subtotal: Double
    let isAvailable: Bool
    let photo: String?
    
    var hasDiscount: Bool {
        guard let discountPrice = discountPrice,
              let discountDouble = Double(discountPrice),
              let baseDouble = Double(basePrice) else { return false }
        return discountDouble < baseDouble
    }
    
    var displayPrice: Double {
        if let discountPrice = discountPrice, let price = Double(discountPrice) {
            return price
        }
        return Double(basePrice) ?? 0
    }
    
    var savings: Double {
        guard let discountPrice = discountPrice,
              let discountDouble = Double(discountPrice),
              let baseDouble = Double(basePrice) else { return 0 }
        return baseDouble - discountDouble
    }
    
    var totalSavings: Double {
        return savings * Double(quantity)
    }
}

struct ProductVariation: Codable,Equatable,Identifiable {
    let id: Int
    let name: String
    let price: Double
    let stock: Int
    
    var isInStock: Bool {
        return stock > 0
    }
}

extension BasketProduct {
    var formattedCurrentPrice: String {
        return String(format: "%.2f TMT", currentPrice)
    }
    
    var formattedBasePrice: String {
        return String(format: "%.2f TMT", basePrice)
    }
    
    var formattedSubtotal: String {
        return String(format: "%.2f TMT", subtotal)
    }
    
    var canAddToCart: Bool {
        return isAvailable && (variation?.isInStock ?? true)
    }
}
