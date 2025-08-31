//
//  HomeResponse.swift
//  ZenModaIOS
//
//  Created by Shahruh on 05.07.2025.
//

import Foundation

struct HomeSection: Codable {
    let title: LocalizedString
    let slug: String
    let allBtn: Bool
    let type: HomeSectionType
    let products: [Product]?
    let categories: ResponseModel<Category>?
    let brands: [Brand]?
    let markets: [Store]?
    let banners: [Banner]?
    
    var displayStyle: DisplayStyle {
        if type == .brands || type == .markets {
            return .grid
        } else {
            return .horizontalScroll
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title,
             slug,
             allBtn,
             type,
             products,
             categories,
             brands,
             markets,
             banners
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(LocalizedString.self, forKey: .title)  // Changed from String to LocalizedString
        slug = try container.decode(String.self, forKey: .slug)
        allBtn = try container.decode(Bool.self, forKey: .allBtn)
        type = try container.decode(HomeSectionType.self, forKey: .type)
        categories = try container.decodeIfPresent(ResponseModel<Category>.self, forKey: .categories)
        products = try container.decodeIfPresent([Product].self, forKey: .products)
        brands = try container.decodeIfPresent([Brand].self, forKey: .brands)
        markets = try container.decodeIfPresent([Store].self, forKey: .markets)
        banners = try container.decodeIfPresent([Banner].self, forKey: .banners)
    }
}

enum DisplayStyle: Codable {
    case grid
    case horizontalScroll
}

enum HomeSectionType: String, Codable {
    case recent = "recent"
    case speciallyForYou = "specially_for_you"
    case popularCategories = "popular_categories"
    case mostViewed = "most_viewed"
    case brands = "brands"
    case markets = "markets"
    case cheapProducts = "cheap_products"
}

struct SubCategory: Codable, Equatable, Identifiable {
    let id: String
    let name: LocalizedString
    let slug: String?
    let order: String?
    let photo: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, order, photo
    }
}

struct Category: Codable, Equatable, Identifiable {
    let id: String
    let name: LocalizedString
    let catalogId: String?
    let photo: String?
    let productCount: Int64?
    let viewCount: Int64?
    let subcategories: [SubCategory]?
    
    enum CodingKeys: String, CodingKey {
        case id, name,catalogId,productCount,viewCount, photo, subcategories
    }
}

struct Catalog: Codable, Equatable, Identifiable {
    let id: String
    let name: LocalizedString
    let slug: String?
    let order: String?
    let categories: [Category]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, order, categories
    }
}

struct Brand: Codable, Identifiable {
    let id: Int
    let name: String
    let photo: String
    
    var logoUrl: String? {
        return photo.isEmpty ? nil : photo
    }
    
    var backgroundColor: String? {
        return nil
    }
    
    var isPopular: Bool {
        return false
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, photo
    }
}

struct LocalizedString: Codable,Equatable {
    let ru: String
    let tk: String
    
    var localizedValue: String {
        if Locale.current.languageCode == "ru" {
            return ru
        }
        return tk
    }
}

struct TopProductImage: Codable, Identifiable {
    let id: String
    let imageURL: String
}

struct Photo: Codable {
    let path: String
    
    enum CodingKeys: String, CodingKey {
        case path
    }
}

struct Product: Codable, Identifiable {
    let id: String
    let variationId: String?
    let name: LocalizedString?
    let description: LocalizedString?
    let slug: String?
    let basePrice: String?
    let discountPrice: String?
    let discountPercentage: Int?
    let currency: String?
    let stock: Int?
    let rating: Double?
    let viewCount: Int?
    let quantity: Int?
    let isNew: Bool?
    let isFeatured: Bool?
    let isRecommended: Bool?
    let isInWishlist: Bool?
    let isInComparison: Bool?
    var isInCart: Bool?
    let reviewCount: Int?
    let saleEndDate: String?
    let store: Store?
    let photo: String?
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id,
             variationId,
             name,
             description,
             slug,
             basePrice,
             discountPrice,
             discountPercentage,
             currency,
             stock,
             rating,
             viewCount,
             quantity,
             isNew,
             isFeatured,
             isRecommended,
             isInWishlist,
             isInComparison,
             isInCart,
             reviewCount,
             saleEndDate,
             store,
             photo
    }
}

extension Product {
    
    var hasDiscount: Bool {
        guard let basePrice = basePrice, let discountPrice = discountPrice,
              let basePriceDouble = Double(basePrice), let discountPriceDouble = Double(discountPrice) else { return false }
        return discountPriceDouble < basePriceDouble
    }
    
    var calculatedDiscountPercentage: Int? {
        guard let basePrice = basePrice, let discountPrice = discountPrice,
              let basePriceDouble = Double(basePrice), let discountPriceDouble = Double(discountPrice), hasDiscount else { return nil }
        return Int(((basePriceDouble - discountPriceDouble) / basePriceDouble) * 100)
    }
    
    var formattedCurrentPrice: String {
        guard let discountPrice = discountPrice else { return "" }
        return "\(discountPrice) \(currency ?? "TMT")"
    }
    
    var formattedOriginalPrice: String? {
        guard let basePrice = basePrice, hasDiscount else { return nil }
        return "\(basePrice) \(currency ?? "TMT")"
    }
    
    var displayName: String {
        return name?.localizedValue ?? ""
    }
    
    var displayDescription: String {
        return description?.localizedValue ?? ""
    }
}

struct Store: Codable, Identifiable {
    let id: String
    let name: String?
    let description: String?
    let logoURL: String?
    let isOfficial: Bool?
    let topProducts: [TopProductImage]?
}

struct Banner: Codable, Identifiable {
    let id: Int
    let name: String?
    let link: String?
    let photo: String?
    let targetType: String
    let type: String
    let priority: Int
    let itemId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, link, photo, targetType, type, priority, itemId
    }
}

extension HomeSection {
    var hasContent: Bool {
        switch type {
        case .recent, .speciallyForYou, .mostViewed, .cheapProducts:
            return !(products?.isEmpty ?? true)
        case .popularCategories:
            return !(categories?.data?.isEmpty ?? true)
        case .brands:
            return !(brands?.isEmpty ?? true)
        case .markets:
            return !(markets?.isEmpty ?? true)
        }
    }
    
    var itemCount: Int {
        switch type {
        case .recent, .speciallyForYou, .mostViewed, .cheapProducts:
            return products?.count ?? 0
        case .popularCategories:
            return categories?.data?.count ?? 0
        case .brands:
            return brands?.count ?? 0
        case .markets:
            return markets?.count ?? 0
        }
    }
}

extension Brand {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        if let photosString = try? container.decode(String.self, forKey: .photo) {
            photo = photosString
        } else if let photosArray = try? container.decode([Photo].self, forKey: .photo) {
            photo = photosArray.first?.path ?? ""
        } else {
            photo = ""
        }
    }
}
