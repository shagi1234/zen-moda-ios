//
//  ProfileView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 24.06.2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    @EnvironmentObject var coordinator: Coordinator
    @State private var showLanguageMenu = false
    var scrollToTopCallback: ((@escaping () -> Void) -> Void)?
    
    @AppStorage("language") var language = Language.english.code
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            ScrollView(showsIndicators: false){
                VStack(spacing: 0) {
                    menuItemsSection
                    
                    Spacer().frame(height: 60)
                }
            }
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
                    Text(Defaults.token.isEmpty ? "not_logged_in".localizedString() : (Defaults.username.isEmpty ? "Empty Name" : Defaults.username))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    if !Defaults.token.isEmpty {
                        Text(Defaults.phoneNumber.isEmpty ? "Empty Phone" : Defaults.phoneNumber)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    coordinator.navigateTo(page: .profile)
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
            .contentShape(Rectangle())
            .padding(.horizontal, 20)
            .padding(.top, 50)
            .padding(.bottom, 20)
            .pressWithAnimation {
                coordinator.navigateTo(page: .profile)
            }
        
        }
        .background(
            Color.blue
                .ignoresSafeArea(edges: .top)
        )
    }
    
    private var menuItemsSection: some View {
        VStack(spacing: 0) {
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
            
            // Language Section with Menu
            VStack(spacing: 0) {
                Menu {
                    Button(action: {
                        changeLanguage(to: "en")
                    }) {
                        HStack {
                            Text("English")
                            if language == Language.english.code {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    
                    Button(action: {
                        changeLanguage(to: "tk")
                    }) {
                        HStack {
                            Text("Türkmen")
                            if language == Language.turkmen.code {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    
                    Button(action: {
                        changeLanguage(to: "ru")
                    }) {
                        HStack {
                            Text("Русский")
                            if language == Language.russian.code {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("language".localized)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(getCurrentLanguageDisplayName())
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.secondary)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .contentShape(Rectangle())
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            Text("help".localized)
                .font(.system(size: 14, weight: .medium))
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
            
            Text("information".localized)
                .font(.system(size: 14, weight: .medium))
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
    }
    
    private func changeLanguage(to languageCode: String) {
        language = languageCode
    }
    
    private func getCurrentLanguageDisplayName() -> String {
        let currentLang = language
        switch currentLang {
        case "en":
            return "English"
        case "tk":
            return "Türkmen"
        case "ru":
            return "Русский"
        default:
            return "English"
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
                        .font(.system(size: 14, weight: .regular))
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
    SettingsView()
}
