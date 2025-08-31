//
//  HomeRepositoryImpl.swift
//  ZenModaIOS
//
//  Created by Shahruh on 29.06.2025.
//

import Combine
import Foundation

class HomeRepositoryImpl: HomeRepository {
    func getHomeData() -> AnyPublisher<[HomeSection], NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.getHome) { (result: Result<[HomeSection], NetworkError>) in
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
