//
//  CategoryItemView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 06.07.2025.
//

import SwiftUI
import Kingfisher

struct CategoryItemView: View {
    let category: Category
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            KFImage(URL(string: category.photo ?? ""))
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 65, height: 65)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Category Name
            Text(category.name.localizedValue)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? .blue : .primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 32)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .padding(.horizontal, 8)
    }
}

struct SubCategoryItemView: View {
    let category: SubCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            KFImage(URL(string: category.photo ?? ""))
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name.localizedValue)
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
