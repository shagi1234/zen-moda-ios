//
//  CategoriesRepositoryImpl.swift
//  ZenModaIOS
//
//  Created by Shahruh on 06.07.2025.
//

import Combine

class CategoriesRepositoryImpl: CategoriesRepository {
    func getCategories() -> AnyPublisher<ResponseModel<Category>, NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.getCategories){ (result: Result<ResponseModel<Category>, NetworkError>) in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getCatalogs() -> AnyPublisher<ResponseModel<Catalog>, NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.getCatalogs){ (result: Result<ResponseModel<Catalog>, NetworkError>) in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getSubCategories(categoryId: Int64) -> AnyPublisher<ResponseModel<SubCategory>, NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.getSubCategoriesByCategoryId(categoryId)){ (result: Result<ResponseModel<SubCategory>, NetworkError>) in
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
