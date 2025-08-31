//
//  MainTabbarView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 16.06.2025.
//

import SwiftUI
import NavigationBackport

struct MainTabbarView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    @State private var homeScrollToTop: (() -> Void)? = nil
    @State private var categoriesScrollToTop: (() -> Void)? = nil
    @State private var basketScrollToTop: (() -> Void)? = nil
    @State private var favoritesScrollToTop: (() -> Void)? = nil
    @State private var profileScrollToTop: (() -> Void)? = nil
    
    @State private var basketItemCount: Int = 12
    
    private let tabBarHeight: CGFloat = 60
    private var safeArea: UIEdgeInsets {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window.safeAreaInsets
        }
        return UIEdgeInsets()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0){
                TabView(selection: $coordinator.selectedInd) {
                    
                    NBNavigationStack(path: $coordinator.paths[0]) {
                        HomeScreenView(scrollToTopCallback: { action in
                            self.homeScrollToTop = action
                        })
                        .nbNavigationDestination(for: Page.self) { page in
                            coordinator.view(for: page)
                        }
                    }
                    .environmentObject(coordinator)
                    .tag(0)
                    
                    NBNavigationStack(path: $coordinator.paths[1]) {
                        CategoriesView(scrollToTopCallback: { action in
                            self.categoriesScrollToTop = action
                        })
                        .nbNavigationDestination(for: Page.self) { page in
                            coordinator.view(for: page)
                        }
                    }
                    .environmentObject(coordinator)
                    .tag(1)
                    
                    NBNavigationStack(path: $coordinator.paths[2]) {
                        BasketView(scrollToTopCallback: { action in
                            self.basketScrollToTop = action
                        })
                        .nbNavigationDestination(for: Page.self) { page in
                            coordinator.view(for: page)
                        }
                    }
                    .environmentObject(coordinator)
                    .tag(2)
                    
                    NBNavigationStack(path: $coordinator.paths[3]) {
                        FavoritesView(scrollToTopCallback: { action in
                            self.favoritesScrollToTop = action
                        })
                        .nbNavigationDestination(for: Page.self) { page in
                            coordinator.view(for: page)
                        }
                    }
                    .environmentObject(coordinator)
                    .tag(3)
                    
                    NBNavigationStack(path: $coordinator.paths[4]) {
                        SettingsView(scrollToTopCallback: { action in
                            self.profileScrollToTop = action
                        })
                        .nbNavigationDestination(for: Page.self) { page in
                            coordinator.view(for: page)
                        }
                    }
                    .environmentObject(coordinator)
                    .tag(4)
                }
                .tabViewStyle(DefaultTabViewStyle())
                
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 0.5)
                    
                    HStack(spacing: 0) {
                        TabItemView(
                            data: .home,
                            selectedInd: $coordinator.selectedInd,
                            onTabPressed: handleTabSelection
                        )
                        
                        TabItemView(
                            data: .categories,
                            selectedInd: $coordinator.selectedInd,
                            onTabPressed: handleTabSelection
                        )
                        
                        TabItemView(
                            data: .basket,
                            selectedInd: $coordinator.selectedInd,
                            onTabPressed: handleTabSelection,
                            badgeCount: basketItemCount
                        )
                        
                        TabItemView(
                            data: .favorites,
                            selectedInd: $coordinator.selectedInd,
                            onTabPressed: handleTabSelection
                        )
                        
                        TabItemView(
                            data: .profile,
                            selectedInd: $coordinator.selectedInd,
                            onTabPressed: handleTabSelection
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, max(8, safeArea.bottom))
                    .frame(height: tabBarHeight + safeArea.bottom)
                    .background(Color.white)
                }
            }
        }
        .onAppear {
            UITabBar.appearance().isHidden = true
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .gesture(DragGesture()
            .onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
    }
    
    private func handleTabSelection(tabIndex: Int) {
        if coordinator.selectedInd == tabIndex {
            if !coordinator.paths[tabIndex].isEmpty {
                coordinator.paths[tabIndex].removeLast(coordinator.paths[tabIndex].count)
            } else {
                switch tabIndex {
                case 0: homeScrollToTop?()
                case 1: categoriesScrollToTop?()
                case 2: basketScrollToTop?()
                case 3: favoritesScrollToTop?()
                case 4: profileScrollToTop?()
                default: break
                }
            }
        }
        
        coordinator.selectedInd = tabIndex
    }
}
