//
//  BrandCardView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 29.06.2025.
//

import SwiftUI
import Kingfisher

struct BrandCardView: View {
    let brand: Brand
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.08))
                .frame(width: 100, height: 80)
                .overlay(
                    Group {
                        if let logoUrl = brand.logoUrl, let url = URL(string: logoUrl) {
                            
                            KFImage(url)
                                .placeholder {
                                    Text(String(brand.name.prefix(1)))
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(brand.backgroundColor?.hexColor ?? Color.black)
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                                .cornerRadius(12)
                            
                        } else {
                            Text(String(brand.name.prefix(1)))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(brand.backgroundColor?.hexColor ?? Color.black)
                        }
                    }
                )
            
            Text(brand.name)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
        }
        .padding(.horizontal, 4)
    }
}
