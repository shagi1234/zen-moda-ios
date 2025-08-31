//
//  SectionHeaderView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 29.06.2025.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let showSeeAll: Bool
    let onSeeAllTapped: (() -> Void)?
    
    init(title: String, showSeeAll: Bool = true, onSeeAllTapped: (() -> Void)? = nil) {
        self.title = title
        self.showSeeAll = showSeeAll
        self.onSeeAllTapped = onSeeAllTapped
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
            Spacer()
            
            if showSeeAll {
                Button(action: {
                    onSeeAllTapped?()
                }) {
                    Text("key_see_all".localizedString())
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
