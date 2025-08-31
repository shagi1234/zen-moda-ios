//
//  BasketViewModel.swift
//  ZenModaIOS
//
//  Created by Shahruh on 17.07.2025.
//

import SwiftUI
import Combine

class BasketViewModel: ObservableObject {
    @Published var basketItems: [BasketProduct] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let cardRepository: CardRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(cardRepository: CardRepository = CardRepositoryImpl()) {
        self.cardRepository = cardRepository
        loadBasketItems()
    }
    
    func loadBasketItems() {
        isLoading = true
        errorMessage = nil
        
        cardRepository.getAllProductsInBasket()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.basketItems = response.data
                }
            )
            .store(in: &cancellables)
    }
    
    func updateQuantity(basketItemId: String, quantity: Int) {
        let request = RequestUpdateToCardItem(quantity: quantity)
        
        cardRepository.updateCard(basketId: "\(basketItemId)", request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.loadBasketItems()
                }
            )
            .store(in: &cancellables)
    }
    
    func deleteItem(productId: String, variation: Int?) {
        cardRepository.deleteFromCard(productId: "\(productId)", variation: "\(variation ?? 0)")
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.loadBasketItems()
                }
            )
            .store(in: &cancellables)
    }
    
    func clearBasket() {
        cardRepository.clearCard()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.loadBasketItems()
                }
            )
            .store(in: &cancellables)
    }
    
    var totalAmount: Double {
        return basketItems.reduce(0) { $0 + $1.subtotal }
    }
    
    var totalSavings: Double {
        return basketItems.reduce(0) { $0 + $1.totalSavings }
    }
    
    var itemCount: Int {
        return basketItems.reduce(0) { $0 + $1.quantity }
    }
}

