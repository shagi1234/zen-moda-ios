//
//  AuthRepository 2.swift
//  ZenModaIOS
//
//  Created by Shahruh on 25.06.2025.
//

import Combine

protocol UserRepository {
    func getUser(id: String) -> AnyPublisher<ResponseGetUser, NetworkError>
//    func delete(id: String) -> AnyPublisher<ResponseGetUser, NetworkError>
}
