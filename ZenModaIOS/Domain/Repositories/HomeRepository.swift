//
//  HomeRepository.swift
//  ZenModaIOS
//
//  Created by Shahruh on 29.06.2025.
//

import Combine

protocol HomeRepository {
    func getHomeData() -> AnyPublisher<[HomeSection], NetworkError>
}
