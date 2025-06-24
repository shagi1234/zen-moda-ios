//
//  HomeView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 24.06.2025.
//


import SwiftUI

struct HomeView: View {
    var scrollToTopCallback: ((@escaping () -> Void) -> Void)?
    
    var body: some View {
        Text("Home")
    }
}

#Preview {
    HomeView()
}
