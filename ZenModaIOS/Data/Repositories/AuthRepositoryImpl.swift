//
//  AuthRepositoryIMpl.swift
//  ZenModaIOS
//
//  Created by Shahruh on 16.06.2025.
//

import Combine

class AuthRepositoryImpl: AuthRepository {
    
    func login(request: RequestLogin) -> AnyPublisher<ResponseLogin, NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.login(request)) { (result: Result<ResponseLogin, NetworkError>) in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func confirm(request: RequestConfirmOtp) -> AnyPublisher<ResponseConfirmOtp, NetworkError> {
        return Future { promise in
            Network.perform(endpoint: Endpoints.confirmOtp(request)) { (result: Result<ResponseConfirmOtp, NetworkError>) in
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
