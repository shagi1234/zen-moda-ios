//
//  AuthRepository.swift
//  ZenModaIOS
//
//  Created by Shahruh on 16.06.2025.
//

import Combine

protocol AuthRepository {
    func login(request: RequestLogin) -> AnyPublisher<ResponseLogin, NetworkError>
    func confirm(request: RequestConfirmOtp) -> AnyPublisher<ResponseConfirmOtp, NetworkError>
}
