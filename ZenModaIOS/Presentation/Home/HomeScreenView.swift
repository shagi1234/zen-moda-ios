//
//  HomeView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 24.06.2025.
//

import SwiftUI

struct HomeScreenView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State var searchText = ""
    var scrollToTopCallback: ((@escaping () -> Void) -> Void)?
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.2)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        searchBarView
                        
                        if let sections = viewModel.homeData {
                            ForEach(sections, id: \.slug) { section in
                                sectionView(for: section)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadHomeData()
        }
        .alert("error".localizedString(), isPresented: $viewModel.showError) {
            Button("ok".localizedString()) {
                viewModel.showError = false
            }
        } message: {
            Text(viewModel.errorMessage ?? "unknown_error".localizedString())
        }
    }
    
    private var searchBarView: some View {
        HStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search from Zen moda", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(.top, 8)
            
            Button(action: {
                // Handle notifications
            }) {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.8))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "bell.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: 8, y: -8)
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func sectionView(for section: HomeSection) -> some View {
        VStack(spacing: 12) {
            
            if let banners = section.banners, !banners.isEmpty {
                bannerSectionView(banners: banners)
            }
            
            SectionHeaderView(title: section.title.localizedValue)
            
            if let categories = section.categories, !(categories.data ?? []).isEmpty {
                categorySectionView(categories: categories.data ?? [])
            }
            
            if let products = section.products, !products.isEmpty {
                productSectionView(products: products, displayStyle: section.displayStyle)
            }
            
            if let brands = section.brands, !brands.isEmpty {
                brandSectionView(brands: brands)
            }
            
            if let markets = section.markets, !markets.isEmpty {
                storeSectionView(stores: markets)
            }
        }
    }
    
    private func bannerSectionView(banners: [Banner]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(banners) { banner in
                    BannerView(banner: banner)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func categorySectionView(categories: [Category]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories) { category in
                    CategoryCard(category: category)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func productSectionView(products: [Product], displayStyle: DisplayStyle) -> some View {
        VStack {
            if displayStyle == .grid {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ], spacing: 12) {
                    ForEach(products) { product in
                        ProductCardView(product: product)
                    }
                }
                .padding(.horizontal, 16)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(products) { product in
                            ProductCardView(product: product)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
    
    private func storeSectionView(stores: [Store]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(stores, id: \.id) { store in
                    StoreCardView(store: store)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func brandSectionView(brands: [Brand]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(brands) { brand in
                    BrandCardView(brand: brand)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview{
    HomeScreenView()
}
