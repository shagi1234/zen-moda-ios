//
//  NameEntryView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 16.06.2025.
//

import SwiftUI

struct NameEntryView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 32) {

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
            
            VStack(spacing: 24) {
                
                Image(.people)
                    .background(
                        Circle()
                            .fill(Color.bgBase)
                            .frame(width: 56, height: 56)
                    )
                    .foregroundColor(Color.accentColor)
                
                VStack(spacing: 8) {
                    Text("enter_your_name".localized)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("enter_name_choose_gender".localized)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("name".localized)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    TextField("name_placeholder".localizedString(), text: $viewModel.fullName)
                        .font(.system(size: 16))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
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
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("gender".localized)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    VStack(spacing: 8) {
                        GenderOptionView(
                            title: "male".localizedString(),
                            isSelected: viewModel.selectedGender == 0
                        ) {
                            viewModel.selectedGender = 0
                        }
                        
                        GenderOptionView(
                            title: "female".localizedString(),
                            isSelected: viewModel.selectedGender == 1
                        ) {
                            viewModel.selectedGender = 1
                        }
                    }
                }
            }
            
            // Continue Button
            Button(action: {
                viewModel.completeRegistration()
            }) {
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
                .background(viewModel.isNameValid ? Color.accentColor : Color.gray.opacity(0.3))
                .cornerRadius(8)
            }
            .disabled(!viewModel.isNameValid || viewModel.isLoading)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }
}

struct GenderOptionView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Radio button
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 20, height: 20)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 10, height: 10)
                    }
                }
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.backgroundApp : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                Color.borderLight,
                                lineWidth: 1
                            )
                    )
            )
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NameEntryView(viewModel: AuthViewModel())
}
