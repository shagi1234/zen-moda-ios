//
//  PhoneNumberView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 16.06.2025.
//

import SwiftUI

struct PhoneNumberView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 24) {
                Image(.logo)
                    .frame(width: 90,height: 50)
                
                VStack(spacing: 8) {
                    Text("welcome".localized)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("enter_phone_verification_message".localized)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("phone".localized)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                HStack {
                    Text("+993")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .padding(.leading, 16)
                    
                    TextField("phone_placeholder".localizedString(), text: $viewModel.phoneNumber)
                        .font(.system(size: 16))
                        .keyboardType(.phonePad)
                        .onChange(of: viewModel.phoneNumber) { newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered != newValue || filtered.count > 8 {
                                viewModel.phoneNumber = String(filtered.prefix(8))
                            }
                        }
                }
                .padding(.vertical, 12)
                .padding(.trailing, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.backgroundApp)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    Color.borderLight,
                                    lineWidth: 1
                                )
                        )
                )
                .cornerRadius(8)
            }
            
            // Continue Button
            Button(action: {
                viewModel.sendOTP()
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    
                    Text("verify".localized)
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(viewModel.isPhoneValid ? Color.accentColor : Color.gray.opacity(0.3))
                .cornerRadius(8)
            }
            .disabled(!viewModel.isPhoneValid || viewModel.isLoading)
            
            HStack(alignment: .top, spacing: 12) {
                Button(action: {
                    viewModel.acceptedTerms.toggle()
                }) {
                    Image(systemName: viewModel.acceptedTerms ? "checkmark.square.fill" : "square")
                        .font(.system(size: 20))
                        .foregroundColor(viewModel.acceptedTerms ? .blue : .gray)
                }
                
                Button(action: {
                    print("Terms tapped")
                }) {
                    Text("terms_agreement_full".localized)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 40)
    }
}

#Preview {
    PhoneNumberView(viewModel: AuthViewModel())
}
