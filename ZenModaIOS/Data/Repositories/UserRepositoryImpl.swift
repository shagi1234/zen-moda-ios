//
//  AuthRepositoryImpl 2.swift
//  ZenModaIOS
//
//  Created by Shahruh on 25.06.2025.
//


import Combine

class UserRepositoryImpl: UserRepository {
    func getUser(id: String) -> AnyPublisher<ResponseGetUser, NetworkError> {
        let additionalUrl = "/\(id)"
        return Future { promise in
            Network.performWithCustomPath(endpoint: Endpoints.getUser,additionalPath: additionalUrl) { (result: Result<ResponseGetUser, NetworkError>) in
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
