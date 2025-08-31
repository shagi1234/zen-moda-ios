//
//  CategoriesRepository.swift
//  ZenModaIOS
//
//  Created by Shahruh on 06.07.2025.
//

import Combine

protocol CategoriesRepository {
    func getCategories() -> AnyPublisher<ResponseModel<Category>, NetworkError>
    func getCatalogs() -> AnyPublisher<ResponseModel<Catalog>, NetworkError>
    func getSubCategories(categoryId: Int64) -> AnyPublisher<ResponseModel<SubCategory>, NetworkError>
}
