//
//  CategoriesView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 06.07.2025.
//

import SwiftUI
import Combine

struct CategoriesView: View {
    var scrollToTopCallback: ((@escaping () -> Void) -> Void)?
    
    @StateObject var viewModel = CategoriesVM()
    @State private var searchText = ""
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 0) {
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
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.catalogs) { catalog in
                        Text(catalog.name.localizedValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(viewModel.selectedCatalogId == catalog.id ? .white : .primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(viewModel.selectedCatalogId == catalog.id ? Color.black : Color.gray.opacity(0.1))
                            )
                            .onTapGesture {
                                viewModel.selectCatalog(catalog.id)
                            }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 12)
            
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    if viewModel.isLoadingCatalogs {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(viewModel.currentCategories) { category in
                                    CategoryItemView(
                                        category: category,
                                        isSelected: viewModel.selectedCategoryId == category.id
                                    )
                                    .padding(.top, 3)
                                    .onTapGesture {
                                        viewModel.selectCategory(category.id)
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(width: 100)
                .background(Color.white)
                .overlay(
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 1),
                    alignment: .trailing
                )
                
                VStack(spacing: 0) {
                    if let selectedCategory = viewModel.selectedCategory {
                        HStack {
                            Text(selectedCategory.name.localizedValue)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.05))
                    }
                    
                    if viewModel.isLoadingCatalogs {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollViewReader { proxy in
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 8) {
                                    ForEach(viewModel.currentSubCategories) { subCategory in
                                        SubCategoryItemView(category: subCategory)
                                            .onTapGesture {
                                                // Handle subcategory selection
                                            }
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .id("subCategoriesTop")
                            }
                            .onAppear {
                                scrollToTopCallback? {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        proxy.scrollTo("subCategoriesTop", anchor: .top)
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.02))
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadCatalogs()
        }
    }
}

#Preview {
    CategoriesView()
}
