//
//  BannerView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 29.06.2025.
//


import SwiftUI
import Kingfisher

struct BannerView: View {
    let banner: Banner
    
    var body: some View {
        ZStack {
            KFImage(URL(string: banner.photo ?? ""))
                .placeholder {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        )
                }
                .onFailure { error in
                    print("Banner image failed to load: \(error)")
                }
            
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 32,height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        
        }
        .frame(height: 120)
        .onTapGesture {
            handleBannerTap()
        }
    }
    
    private func handleBannerTap() {
        print("Banner tapped: \(banner.name)")
    }
}
