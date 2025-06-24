//
//  ProfileViewModel.swift
//  ZenModaIOS
//
//  Created by Shahruh on 25.06.2025.
//

import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userData: UserData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    let userRepository: UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(userRepository: UserRepository = UserRepositoryImpl()) {
        self.userRepository = userRepository
    }
    
    func getUserData() {
        userRepository.getUser(id: Defaults.userId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.userData = response.user
                }
            )
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: NetworkError) {
        errorMessage = error.userFriendlyMessage
        showError = true
    }
}
