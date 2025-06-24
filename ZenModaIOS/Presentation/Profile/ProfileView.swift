//
//  ProfileView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 24.06.2025.
//


import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State var userData: UserData?
    var scrollToTopCallback: ((@escaping () -> Void) -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Section
            headerSection
            
            ScrollView(showsIndicators: false){
                VStack(spacing: 0) {
                    // Menu Items
                    menuItemsSection
                    
                    Spacer().frame(height: 60)
                }
            }
        }
        .onAppear{
            if viewModel.userData == nil {
                viewModel.getUserData()
            }
        }
        .onReceive(viewModel.$userData) {
            userData = $0
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(userData?.fullname ?? "n/a")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(userData?.phone_number ?? "n/a")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Button(action: {
                    // Edit profile action
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 50)
            .padding(.bottom, 20)
        }
        .background(
            Color.blue
                .ignoresSafeArea(edges: .top)
        )
    }
    
    private var menuItemsSection: some View {
        VStack(spacing: 0) {
            // Main Menu Items
            VStack(spacing: 0) {
                ProfileMenuItem(
                    title: "specifications".localizedString(),
                    action: {}
                )
                
                ProfileMenuItem(
                    title: "price_evaluation".localizedString(),
                    action: {}
                )
                
                ProfileMenuItem(
                    title: "addresses".localizedString(),
                    action: {}
                )
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Language Section
            VStack(spacing: 0) {
                HStack {
                    Text("language".localized)
                        .font(.system(size: 14,weight: .regular))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("turkmen".localized)
                        .font(.system(size: 14,weight: .regular))
                        .foregroundColor(.secondary)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white)
                .pressWithAnimation {
                    
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Help Section
            Text("help".localized)
                .font(.system(size: 14,weight: .medium))
                .foregroundColor(Color.passive)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                ProfileMenuItem(
                    title: "frequently_asked_questions".localizedString(),
                    action: {}
                )
                
                ProfileMenuItem(
                    title: "how_to_place_order".localizedString(),
                    action: {}
                )
                
                ProfileMenuItem(
                    title: "how_to_find_product".localizedString(),
                    action: {}
                )
                
                ProfileMenuItem(
                    title: "delivery_service".localizedString(),
                    action: {}
                )
                
                ProfileMenuItem(
                    title: "zen_fashion_sat".localizedString(),
                    action: {}
                )
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            
            // Information Section
            Text("information".localized)
                .font(.system(size: 14,weight: .medium))
                .foregroundColor(Color.passive)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                ProfileMenuItem(
                    title: "privacy_policy".localizedString(),
                    action: {}
                )
                
                ProfileMenuItem(
                    title: "information_security".localizedString(),
                    action: {}
                )
                
                ProfileMenuItem(
                    title: "why_zen_fashion".localizedString(),
                    action: {}
                )
                
                ProfileMenuItem(
                    title: "contact_us".localizedString(),
                    action: {}
                )
                
                ProfileMenuItem(
                    title: "about_us".localizedString(),
                    action: {}
                )
                
                ProfileMenuItem(
                    title: "open_shop".localizedString(),
                    action: {}
                )
                
                ProfileMenuItem(
                    title: "about_program".localizedString(),
                    action: {},
                    showDivider: false
                )
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
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

struct ProfileMenuItem: View {
    let title: String
    let action: () -> Void
    var showDivider: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack {
                    Text(title)
                        .font(.system(size: 14,weight: .regular))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white)
            }
            .pressAnimation()
            .buttonStyle(PlainButtonStyle())
            
            if showDivider {
                Divider()
                    .padding(.leading, 20)
            }
        }
    }
}
#Preview {
    ProfileView()
}
