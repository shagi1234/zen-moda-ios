//
//  StoreCardView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 29.06.2025.
//

import SwiftUI
import Kingfisher

struct StoreCardView: View {
    let store: Store
    
    var body: some View {
        VStack(spacing: 16) {
            storeHeaderSection
            productImagesSection
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
    
    private var storeHeaderSection: some View {
        VStack(spacing: 12) {
            storeLogoView
            storeNameView
        }
    }
    
    private var storeLogoView: some View {
        Circle()
            .fill(.backgroundApp)
            .frame(width: 45, height: 45)
            .overlay(logoContent)
    }
    
    private var logoContent: some View {
        Group {
            if let logoURL = store.logoURL, let url = URL(string: logoURL) {
                KFImage(url)
                    .placeholder {
                        defaultLogoIcon
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 44,height: 44)
            } else {
                defaultLogoIcon
            }
        }
    }
    
    private var defaultLogoIcon: some View {
        Image(systemName: "bag.fill")
            .font(.system(size: 22))
            .foregroundColor(.black)
    }
    
    private var storeNameView: some View {
        VStack{
            HStack{
                Text(store.name ?? "")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                if store.isOfficial ?? false {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                }
            }
            
            Text(store.description ?? "")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
        }
    }
    
    @ViewBuilder
    private var productDescriptionView: some View {
        if let description = store.description {
            Text(description)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
    }
    
    private var productImagesSection: some View {
        HStack(spacing: 12) {
            if let products = store.topProducts, !products.isEmpty {
                productImagesList
                placeholderImagesList
            } else {
                allPlaceholderImages
            }
        }
    }
    
    private var productImagesList: some View {
        ForEach(Array((store.topProducts ?? []).prefix(3)), id: \.id) { product in
            ProductImageView(productImage: product)
        }
    }
    
    private var placeholderImagesList: some View {
        let productCount = store.topProducts?.count ?? 0
        let placeholderCount = max(0, 3 - min(3, productCount))
        return ForEach(0..<placeholderCount, id: \.self) { _ in
            PlaceholderProductView()
        }
    }
    
    private var allPlaceholderImages: some View {
        ForEach(0..<3, id: \.self) { _ in
            PlaceholderProductView()
        }
    }
}

struct ProductImageView: View {
    let productImage: TopProductImage
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.1))
            .frame(width: 50, height: 60)
            .overlay(imageContent)
    }
    
    private var imageContent: some View {
        Group {
            if let url = URL(string: productImage.imageURL) {
                KFImage(url)
                    .placeholder {
                        ProgressView()
                            .scaleEffect(0.5)
                    }
                    .fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct PlaceholderProductView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.1))
            .frame(width: 50, height: 60)
            .overlay(
                Image(systemName: "photo")
                    .font(.system(size: 20))
                    .foregroundColor(.gray.opacity(0.5))
            )
    }
}
