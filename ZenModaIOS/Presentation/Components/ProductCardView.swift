//
//  ProductCardView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 29.06.2025.
//

import SwiftUI
import Kingfisher

struct ProductCardView: View {
    @EnvironmentObject var coordinator: Coordinator
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                KFImage(URL(string: product.photo ?? ""))
                    .placeholder {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 155,height: 215)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray.opacity(0.5))
                            )
                    }
                    .onFailure { error in
                        print("Product image failed to load: \(error)")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 155,height: 215)
                    .clipped()
                    .cornerRadius(4)
                
                if let percentage = product.calculatedDiscountPercentage {
                    VStack {
                        HStack {
                            Text("\(percentage) %")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .cornerRadius(4)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(8)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            handleFavoriteToggle()
                        }) {
                            Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 16))
                                .foregroundColor(product.isFavorite ? .red : .gray)
                                .padding(8)
                                .background(Color.white.opacity(0.9))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 2)
                        }
                    }
                    Spacer()
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(product.formattedCurrentPrice)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    if let originalPrice = product.formattedOriginalPrice {
                        Text(originalPrice)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .strikethrough()
                    }
                }
                
                Text(product.store?.name ?? "")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
                
                Text(product.name?.localizedValue ?? "")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(product.rating ?? 0) ? "star.fill" : "star")
                                .font(.system(size: 8))
                                .foregroundColor(.orange)
                        }
                    }
                    
                    Text("(\(product.reviewCount ?? 0))")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .frame(width: 170)
        .onTapGesture {
            handleProductTap()
        }
    }
    
    private func handleFavoriteToggle() {
        print("Favorite toggled for product: \(product.name)")
    }
    
    private func handleProductTap() {
        coordinator.navigateTo(page: .product(product.id))
    }
}
