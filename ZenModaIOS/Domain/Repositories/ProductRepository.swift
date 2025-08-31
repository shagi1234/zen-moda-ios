//
//  ProductRepository.swift
//  ZenModaIOS
//
//  Created by Shahruh on 15.07.2025.
//

import Combine

protocol ProductRepository {
    func getProductDetail(id: String) -> AnyPublisher<ProductDetailResponse, NetworkError>
    func getProductQuestions(productId: String,request: RequestGetProductQuestion) -> AnyPublisher<ResponseModel<ProductQuestionResponse>, NetworkError>
    func createProductQuestion(productId: String,request: RequestCreateProductQuestion) -> AnyPublisher<ResponseMessage, NetworkError>
    func getProductReviews(productId: String,request: RequestGetProductReviews) -> AnyPublisher<ProductDetail, NetworkError> 
}
