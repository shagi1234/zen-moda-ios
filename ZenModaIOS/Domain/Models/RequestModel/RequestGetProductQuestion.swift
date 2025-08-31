//
//  RequestGetProductQuestion.swift
//  ZenModaIOS
//
//  Created by Shahruh on 15.07.2025.
//

enum ProductQuestionsStatus: String {
    case pending = "pending"
    case answered = "answered"
    case closed = "closed"
}

struct RequestGetProductQuestion: Codable ,RequestParameters {
    let page: Int
    let size: Int
    let sort: String?//createdAt,desc
}

struct RequestGetProductReviews: Codable ,RequestParameters {
    let page: Int
    let limit: Int
    let sort: String?//createdAt,desc
}

struct RequestCreateProductQuestion: Codable,RequestParameters {
    let content: String
}

struct RequestAddToCard: Codable,RequestParameters {
    let product_id: Int
    let variation_id: Int?
    let quantity: Int
}

struct RequestUpdateToCardItem: Codable,RequestParameters {
    let quantity: Int
}
