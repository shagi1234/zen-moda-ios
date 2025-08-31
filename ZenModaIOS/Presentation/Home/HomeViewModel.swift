//
//  HomeViewModel.swift
//  ZenModaIOS
//
//  Created by Shahruh on 29.06.2025.
//


import Foundation
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var homeData: [HomeSection]?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    let homeRepository: HomeRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(homeRepository: HomeRepository = HomeRepositoryImpl()) {
        self.homeRepository = homeRepository
    }
    
    func loadHomeData() {
        isLoading = true
        errorMessage = nil
        
        homeRepository.getHomeData()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.homeData = response
                }
            )
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: NetworkError) {
        errorMessage = error.userFriendlyMessage
        showError = true
    }
}
