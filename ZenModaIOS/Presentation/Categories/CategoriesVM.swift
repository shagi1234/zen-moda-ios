//
//  CategoriesVM.swift
//  ZenModaIOS
//
//  Created by Shahruh on 06.07.2025.
//
import SwiftUI
import Combine

class CategoriesVM: ObservableObject {
    @Published var catalogs: [Catalog] = []
    @Published var selectedCatalogId: String? = nil
    @Published var selectedCategoryId: String? = nil
    @Published var isLoadingCatalogs: Bool = false
    
    let repository: CategoriesRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: CategoriesRepository = CategoriesRepositoryImpl()) {
        self.repository = repository
    }
    
    func loadCatalogs() {
        isLoadingCatalogs = true
        repository.getCatalogs()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    self.isLoadingCatalogs = false
                    if case .failure(let error) = completion {
                        print("Error loading catalogs: \(error)")
                    }
                },
                receiveValue: { response in
                    self.catalogs = response.data ?? []
                    
                    // Auto-select first catalog and its first category
                    if let firstCatalog = self.catalogs.first {
                        self.selectedCatalogId = firstCatalog.id
                        if let firstCategory = firstCatalog.categories?.first {
                            self.selectedCategoryId = firstCategory.id
                        }
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    var selectedCatalog: Catalog? {
        catalogs.first { $0.id == selectedCatalogId }
    }
    
    var currentCategories: [Category] {
        selectedCatalog?.categories ?? []
    }
    
    var selectedCategory: Category? {
        currentCategories.first { $0.id == selectedCategoryId }
    }
    
    var currentSubCategories: [SubCategory] {
        selectedCategory?.subcategories ?? []
    }
    
    func selectCatalog(_ catalogId: String) {
        selectedCatalogId = catalogId
        // Auto-select first category of the new catalog
        if let firstCategory = selectedCatalog?.categories?.first {
            selectedCategoryId = firstCategory.id
        } else {
            selectedCategoryId = nil
        }
    }
    
    func selectCategory(_ categoryId: String) {
        selectedCategoryId = categoryId
    }
}
