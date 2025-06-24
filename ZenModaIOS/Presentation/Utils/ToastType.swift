//
//  ToastType.swift
//  ZenModaIOS
//
//  Created by Shahruh on 24.06.2025.
//


import SwiftUI

enum ToastType {
    case success
    case error
    case info
}

class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var isPresented = false
    @Published var message = ""
    @Published var toastType : ToastType = .info
    
    private init() {}
    
    func showError(_ message: String? = nil) {
        DispatchQueue.main.async {
            self.message = message ?? "something_went_wrong".localizedString()
            self.toastType = .error
            self.isPresented = true
            
            // Auto-hide after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isPresented = false
            }
        }
    }
    
    func showSuccess(_ message: String) {
        DispatchQueue.main.async {
            self.message = message
            self.toastType = .success
            self.isPresented = true
            
            // Auto-hide after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isPresented = false
            }
        }
    }
    
    func showInfo(_ message: String) {
        DispatchQueue.main.async {
            self.message = message
            self.toastType = .info
            self.isPresented = true
            
            // Auto-hide after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isPresented = false
            }
        }
    }
}
