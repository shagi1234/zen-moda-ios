//
//  Endpoints.swift
//  aydym
//
//  Created by TmCars on 13.03.2024.
//

import Foundation
import Alamofire

enum Endpoints {
    case login(_ request: RequestLogin)
    case confirmOtp(_ request: RequestConfirmOtp)
    case completeRegistration(_ request: RequestUpdateProfile)
    case getUser
    case getHome
    case getCategories
    case getCatalogs
    case getSubCategoriesByCategoryId(_ categoryId: Int64)
    case getProductDetails(_ id: String)
    case getReviews(productId: String,request: RequestGetProductReviews)
    case getQuestions(productId: String,request: RequestGetProductQuestion)
    case createQuestions(_ request: RequestCreateProductQuestion)
    
    case addToCard(_ request: RequestAddToCard)
    case updateCard(basketId: String, request: RequestUpdateToCardItem)
    case deleteFromCard(productId: String,variantId: String? = nil)
    case clearBasket
    case getAllProductsInBasket
}

extension Endpoints: EndpointProtocol {
    var path: String {
        switch self {
        case .login:
            return CONSTANTS.BASE_URL + "/api/auth/login"
            
        case .confirmOtp:
            return CONSTANTS.BASE_URL + "/api/auth/confirm-otp"
        case .completeRegistration:
            return CONSTANTS.BASE_URL + "/api/auth/complete-registration"
        case .getUser:
            return CONSTANTS.BASE_URL + "/api/user"
        case .getHome:
            return CONSTANTS.BASE_URL + "/api/client/home"
        case .getCategories:
            return CONSTANTS.BASE_URL + "/api/client-productCategory?sort=categoryName&sortBy=ASC&size=25"
        case .getSubCategoriesByCategoryId(let id):
            return CONSTANTS.BASE_URL + "/api/client-product-subcategory?sortBy=ASC&categoryId=\(id)"
        case .getCatalogs:
            return CONSTANTS.BASE_URL + "/api/client-catalog?sortBy=ASC"
            
        case .getProductDetails(let id):
            return CONSTANTS.BASE_URL + "/api/product/\(id)/complete"
            
        case .getQuestions(let productId, _):
            return CONSTANTS.BASE_URL + "/api/product-question/\(productId)"
            
        case .getReviews(let productId, _):
            return CONSTANTS.BASE_URL + "/api/reviews-detailed/\(productId)"
            
        case .createQuestions:
            return CONSTANTS.BASE_URL + "/api/product-question"
            
        case .addToCard:
            return CONSTANTS.BASE_URL + "/api/basket/add"
        case .getAllProductsInBasket:
            return CONSTANTS.BASE_URL + "/api/basket"
        case .updateCard(let basketId,_):
            return CONSTANTS.BASE_URL + "/api/basket/update/\(basketId)"
        case .deleteFromCard(let productId,_):
            return CONSTANTS.BASE_URL + "/api/basket/remove/\(productId)"
        case .clearBasket:
            return CONSTANTS.BASE_URL + "/api/basket/clear"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login,
                .confirmOtp,
                .createQuestions,
                .addToCard,
                .completeRegistration:
            return .post
            
        case .updateCard:
            return .put
            
        case .deleteFromCard,
            .clearBasket:
            return .delete
            
        default:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let params):
            return params.asParameters()
        case .confirmOtp(let params):
            return params.asParameters()
        case .completeRegistration(let params):
            return params.asParameters()
        case .createQuestions(let request):
            return request.asParameters()
        case .getQuestions(_,let request):
            return request.asParameters()
        case .getReviews(_,let request):
            return request.asParameters()
        case .addToCard(let request):
            return request.asParameters()
        case .updateCard(_, let request):
            return request.asParameters()
            
        default:
            return nil
        }
    }
    
    var header: HTTPHeaders {
        if Defaults.token.isEmpty {
            return [
                "Content-Type": "application/json",
                "Accept-Language": Defaults.language.lowercased() != "ru" ? "tm" : "ru"
            ]
        } else {
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer " + Defaults.token,
                "Accept-Language": Defaults.language.lowercased() != "ru" ? "tm" : "ru"
            ]
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
