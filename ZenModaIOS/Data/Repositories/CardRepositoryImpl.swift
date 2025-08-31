//
//  CardRepositoryImpl.swift
//  ZenModaIOS
//
//  Created by Shahruh on 17.07.2025.
//

import Combine

class CardRepositoryImpl: CardRepository {
    func addToCard(request: RequestAddToCard) -> AnyPublisher<ResponseMessage, NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.addToCard(request)) { (result: Result<ResponseMessage, NetworkError>) in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateCard(basketId: String, request: RequestUpdateToCardItem) -> AnyPublisher<ResponseMessage, NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.updateCard(basketId: basketId, request: request)) { (result: Result<ResponseMessage, NetworkError>) in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteFromCard(productId: String, variation: String?) -> AnyPublisher<ResponseMessage, NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.deleteFromCard(productId: productId, variantId: variation)) { (result: Result<ResponseMessage, NetworkError>) in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func clearCard() -> AnyPublisher<ResponseMessage, NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.clearBasket) { (result: Result<ResponseMessage, NetworkError>) in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getAllProductsInBasket() -> AnyPublisher<BasketResponse, NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.getAllProductsInBasket) { (result: Result<BasketResponse, NetworkError>) in
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
