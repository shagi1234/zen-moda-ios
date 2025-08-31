//
//  ReviewsScreen.swift
//  ZenModaIOS
//
//  Created by Shahruh on 14.07.2025.
//


import SwiftUI

struct ReviewsScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("3.5")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.black)
                        
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 16))
                        }
                        
                        Text("2394 teswir")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(spacing: 4) {
                        ForEach((1...5).reversed(), id: \.self) { rating in
                            HStack(spacing: 8) {
                                Text("\(rating)")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 12))
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .frame(height: 8)
                                            .foregroundColor(Color.gray.opacity(0.2))
                                        
                                        Rectangle()
                                            .frame(width: progressWidth(for: rating, totalWidth: geometry.size.width), height: 8)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .frame(height: 8)
                                
                                Text(countText(for: rating))
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 30, alignment: .trailing)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.3))
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0..<5) { _ in
                        reviewRow
                            .padding(.horizontal, 20)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.1))
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Teswirler")
    }
    
    private func progressWidth(for rating: Int, totalWidth: CGFloat) -> CGFloat {
        let progress: CGFloat
        switch rating {
        case 5: progress = 0.8 // 1011 reviews
        case 4: progress = 0.3 // 174 reviews
        case 3: progress = 0.1 // 12 reviews
        case 2: progress = 0.02 // 2 reviews
        case 1: progress = 0.02 // 4 reviews
        default: progress = 0
        }
        return totalWidth * progress
    }
    
    private func countText(for rating: Int) -> String {
        switch rating {
        case 5: return "1011"
        case 4: return "174"
        case 3: return "12"
        case 2: return "2"
        case 1: return "4"
        default: return "0"
        }
    }
    
    private var reviewRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 2) {
                ForEach(0..<5) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 14))
                }
            }
            
            Text("Diam, nisl iaculis arcu vitae egestas dolor magna risus neque suscipit magnis neque quis velit a odio morbi enim, urna adipiscing risus orci magna magna")
                .font(.system(size: 16))
                .foregroundColor(.black)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
            
            HStack {
                Text("Aman Amanow")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("16.03.2025")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 16)
    }
}

struct ReviewsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsScreen()
    }
}
