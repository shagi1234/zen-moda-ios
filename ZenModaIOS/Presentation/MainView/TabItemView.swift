//
//  TabItemView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 24.06.2025.
//

import SwiftUI
import Resolver

struct TabItemView: View {
    var data: TabItemData
    @Binding var selectedInd: Int
    var onTabPressed: ((Int) -> Void)?
    var badgeCount: Int = 0
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Image(systemName: selectedInd == data.rawValue ? data.image : data.imageInactive)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(selectedInd == data.rawValue ? .accent : .secondary)
                    .frame(width: 22, height: 22)
                
                // Badge
                if data == .basket && badgeCount > 0 {
                    VStack {
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 18, height: 18)
                                
                                Text("\(badgeCount)")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .offset(x: 8, y: -8)
                        }
                        Spacer()
                    }
                }
            }
            .frame(width: 32, height: 32)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            if let onTabPressed = onTabPressed {
                onTabPressed(data.rawValue)
            } else {
                selectedInd = data.rawValue
            }
        }
    }
}

enum TabItemData: Int, CaseIterable {
    case home = 0
    case categories = 1
    case basket = 2
    case favorites = 3
    case profile = 4
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .categories:
            return "Categories"
        case .basket:
            return "Basket"
        case .favorites:
            return "Favorites"
        case .profile:
            return "Profile"
        }
    }
    
    var image: String {
        switch self {
        case .home:
            return "house.fill"
        case .categories:
            return "square.grid.2x2.fill"
        case .basket:
            return "cart.fill"
        case .favorites:
            return "heart.fill"
        case .profile:
            return "person.fill"
        }
    }
    
    var imageInactive: String {
        switch self {
        case .home:
            return "house"
        case .categories:
            return "square.grid.2x2"
        case .basket:
            return "cart"
        case .favorites:
            return "heart"
        case .profile:
            return "person"
        }
    }
}

#Preview{
    MainTabbarView()
        .environmentObject(Coordinator())
}
