//
//  CategoryCard.swift
//  ZenModaIOS
//
//  Created by Shahruh on 05.07.2025.
//

import SwiftUI
import Kingfisher

struct CategoryCard: View {
    let category: Category
    
    var body: some View {
        VStack(spacing: 12) {
            KFImage(URL(string: category.photo ?? ""))
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(category.name.localizedValue)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}
