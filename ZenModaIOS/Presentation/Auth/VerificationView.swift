//
//  VerificationView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 16.06.2025.
//

import SwiftUI

struct VerificationView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .center ,spacing: 32) {
            HStack {
                Button(action: {
                    viewModel.goBack()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
                Spacer()
            }
            
            VStack(alignment: .center,spacing: 16) {
                Image(.message)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(Color.bgBase)
                            .frame(width: 56, height: 56)
                    )
                    .foregroundColor(Color.accentColor)
                
                VStack(alignment: .center,spacing: 8) {
                    Text("verification_code".localized)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("enter_sms_code_message".localized)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            
            OtpFormFieldView(viewModel: viewModel)
                .frame(maxWidth: .infinity,alignment: .center)
            
            Button(action: {
                viewModel.verifyOTP()
            })
            {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    Text("continue".localized)
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(viewModel.isOTPValid ? Color.accentColor : Color.gray.opacity(0.3))
                .cornerRadius(8)
            }
            .disabled(!viewModel.isOTPValid || viewModel.isLoading)
            
            Button(action: {
                viewModel.resendOTP()
            })
            {
                Text(viewModel.canResendOTP ? "resend_code".localizedString() : "resend_code_timer".localizedString() + " \(viewModel.otpTimer)s")
                    .font(.system(size: 14))
                    .foregroundColor(viewModel.canResendOTP ? Color.accentColor : .gray)
            }
            .frame(maxWidth: .infinity,alignment: .center)
            .disabled(!viewModel.canResendOTP)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
}

#Preview {
    VerificationView(viewModel: AuthViewModel())
}
