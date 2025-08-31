//
//  CardRepository.swift
//  ZenModaIOS
//
//  Created by Shahruh on 17.07.2025.
//

import Combine

protocol CardRepository {
    func addToCard(request: RequestAddToCard) -> AnyPublisher<ResponseMessage, NetworkError>
    func updateCard(basketId: String,request: RequestUpdateToCardItem) -> AnyPublisher<ResponseMessage, NetworkError>
    func deleteFromCard(productId: String,variation: String?) -> AnyPublisher<ResponseMessage, NetworkError>
    func clearCard() -> AnyPublisher<ResponseMessage, NetworkError>
    func getAllProductsInBasket() -> AnyPublisher<BasketResponse, NetworkError>
}
