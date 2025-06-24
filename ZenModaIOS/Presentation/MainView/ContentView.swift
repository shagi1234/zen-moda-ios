//
//  ContentView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 07.06.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var coordinator: Coordinator
    @AppStorage("token") var token = ""
    
    var body: some View {
        if token.isEmpty && Defaults.userId.isEmpty  {
            SignUpView()
        } else {
            MainTabbarView()
                .environmentObject(coordinator)
        }
        
    }
}

#Preview {
    ContentView()
}
