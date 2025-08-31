//
//  SizeSelectorBottomSheetWrapper.swift
//  ZenModaIOS
//
//  Created by Shahruh on 21.07.2025.
//

import SwiftUI

struct SizeSelectorBottomSheetWrapper: View {
    let availableSizes: [SizeWithStock]
    let selectedColor: ProductColor?
    let productDetail: ProductDetail?
    @Binding var selectedSize: String?
    let onSizeSelected: (String) -> Void
    let onClose: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("cancel".localizedString()) {
                        onClose()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("select_size".localizedString())
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Empty space for symmetry
                    Text("cancel".localizedString())
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white)
                
                // Product info section
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        // Product image
                        AsyncImage(url: URL(string: selectedColor?.photos.first?.path ?? productDetail?.product.photos.first?.path ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Image(systemName: "photo")
                                .font(.system(size: 32))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 60, height: 60)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            // Original price (crossed out)
                            if let product = productDetail?.product, 
                               product.hasDiscount, 
                               let originalPrice = product.formattedOriginalPrice {
                                Text(originalPrice)
                                    .font(.system(size: 12))
                                    .strikethrough()
                                    .foregroundColor(.gray)
                            }
                            
                            // Current price
                            if let product = productDetail?.product {
                                Text(product.formattedCurrentPrice)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(red: 0.9, green: 0.26, blue: 0.42))
                            }
                            
                            // Product name
                            if let product = productDetail?.product {
                                Text(product.displayName)
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                                    .lineLimit(2)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    // Selected color section
                    if let selectedColor = selectedColor {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("color".localizedString())
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Text(selectedColor.displayName)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                            }
                            
                            // Show only selected color
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.blue, lineWidth: 2)
                                        )
                                        .frame(width: 50, height: 50)
                                    
                                    AsyncImage(url: URL(string: selectedColor.photos.first?.path ?? "")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                    } placeholder: {
                                        Image(systemName: "photo")
                                            .font(.system(size: 20))
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
                .background(Color.white)
                
                Divider()
                
                // Size selection section
                VStack(alignment: .leading, spacing: 16) {
                    Text("size".localizedString())
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(availableSizes, id: \.name) { sizeWithStock in
                                sizeRow(sizeWithStock: sizeWithStock)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .background(Color.white)
                
                // Bottom button area
                VStack(spacing: 0) {
                    Divider()
                    
                    Button(action: {
                        onClose()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("select".localizedString())
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.white)
                }
            }
            .background(Color.white)
        }
    }
    
    private func sizeRow(sizeWithStock: SizeWithStock) -> some View {
        Button(action: {
            onSizeSelected(sizeWithStock.name)
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(sizeWithStock.name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        // Stock indicator
                        if sizeWithStock.stock <= 5 && sizeWithStock.stock > 0 {
                            Text("- \("last_items".localizedString()) \(sizeWithStock.stock) \("items".localizedString())")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 0.9, green: 0.26, blue: 0.42))
                        } else if sizeWithStock.stock == 0 {
                            Text("- \("out_of_stock".localizedString())")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                // Selection indicator
                if selectedSize == sizeWithStock.name {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                } else {
                    Circle()
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
        }
        .disabled(sizeWithStock.stock == 0)
        .opacity(sizeWithStock.stock == 0 ? 0.5 : 1.0)
    }
}
