//
//  ProductsRepositoryImpl.swift
//  ZenModaIOS
//
//  Created by Shahruh on 15.07.2025.
//

import Combine

class ProductsRepositoryImpl: ProductRepository {
    
    func getProductDetail(id: String) -> AnyPublisher<ProductDetailResponse, NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.getProductDetails(id)) { (result: Result<ProductDetailResponse, NetworkError>) in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getProductQuestions(productId: String,request: RequestGetProductQuestion) -> AnyPublisher<ResponseModel<ProductQuestionResponse>, NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.getQuestions(productId: productId,request: request)) { (result: Result<ResponseModel<ProductQuestionResponse>, NetworkError>) in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getProductReviews(productId: String,request: RequestGetProductReviews) -> AnyPublisher<ProductDetail, NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.getReviews(productId: productId,request: request)) { (result: Result<ProductDetail, NetworkError>) in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func createProductQuestion(productId: String,request: RequestCreateProductQuestion) -> AnyPublisher<ResponseMessage, NetworkError> {
        return Future { promise in
            let url = "/\(productId)"
            Network.performWithCustomPath(endpoint: Endpoints.createQuestions(request), additionalPath: url) { (result: Result<ResponseMessage, NetworkError>) in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
}
