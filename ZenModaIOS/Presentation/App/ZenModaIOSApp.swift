//
//  ZenModaIOSApp.swift
//  ZenModaIOS
//
//  Created by Shahruh on 07.06.2025.
//

import SwiftUI

@main
struct ZenModaIOSApp: App {
    @StateObject var localMan = LocalizationManager()
    @StateObject var coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(localMan)
                .environmentObject(coordinator)
                .preferredColorScheme(.light) 
        }
    }
}
