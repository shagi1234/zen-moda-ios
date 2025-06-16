//
//  SignUpView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 16.06.2025.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                switch viewModel.currentStep {
                case .signUp:
                    PhoneNumberView(viewModel: viewModel)
                case .verification:
                    VerificationView(viewModel: viewModel)
                case .nameEntry:
                    NameEntryView(viewModel: viewModel)
                case .completed:
                    MainTabbarView()
                }
            }
        }
        .alert("error".localizedString(), isPresented: $viewModel.showError) {
            Button("OK") {
                viewModel.showError = false
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
