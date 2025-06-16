//
//  Page.swift
//  ZenModaIOS
//
//  Created by Shahruh on 17.06.2025.
//

import NavigationBackport
import SwiftUI
import Resolver

enum Page: Hashable {
    case product
}

class Coordinator: ObservableObject {
    
    @Published var paths = [
        NBNavigationPath(),
        NBNavigationPath(),
        NBNavigationPath(),
        NBNavigationPath(),
        NBNavigationPath()
    ]
    
    @Published var selectedInd = 0
    
    
    @ViewBuilder
    func view(for page: Page) -> some View {
        switch page {
        case .product:
            EmptyView()
        }
    }
    
    func navigateTo(page: Page){
        DispatchQueue.main.async {
            self.paths[self.selectedInd].append(page)
        }
    }
    
    func navigateBack(){
        DispatchQueue.main.async {
            self.paths[self.selectedInd].removeLast()
        }
    }
    
    func popToRoot(){
        DispatchQueue.main.async {
            self.paths[self.selectedInd].removeLast(self.paths[self.selectedInd].count)
        }
    }
}
