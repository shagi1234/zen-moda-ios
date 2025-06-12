//
//  Language.swift
//  ZenModaIOS
//
//  Created by Shahruh on 13.06.2025.
//

import SwiftUI
import Foundation

enum Language: CaseIterable, Identifiable {
    case turkmen
    case russian
    case english
    
    var id: String { code }
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .turkmen:
            return "Türkmençe"
        case .russian:
            return "Русский"
        }
    }
    
    var icon: String {
        switch self {
        case .english:
            return "flag_uk"
        case .turkmen:
            return "flag_tm"
        case .russian:
            return "flag_ru"
        }
    }
    
    var code: String {
        switch self {
        case .english:
            return "en"
        case .turkmen:
            return "tk"
        case .russian:
            return "ru"
        }
    }
    
    static func from(id: String) -> Language {
        return Language.allCases.first(where: { $0.code == id }) ?? .english
    }
}


class LocalizationManager: ObservableObject {
    
    static let shared = LocalizationManager()
    
    @AppStorage("language") var language: String = Language.turkmen.code
    
    var bundle: Bundle? {
        let b = Bundle.main.path(forResource: language, ofType: "lproj") ?? ""
        return Bundle(path: b)
    }
}

@available(watchOS 6.0, *)
@available(macOS 10.15, *)
@available(iOS 14.0, *)
public struct LocalizedView<Content: View>: View {
    @ViewBuilder let content: Content
    @AppStorage("language") private var language: String = ""
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .environment(\.locale, .init(identifier: language))
    }
}


@available(watchOS 6.0, *)
@available(macOS 10.15, *)
@available(iOS 14.0, *)
public extension String {
    var localized: LocalizedStringKey {
        return LocalizedStringKey(self)
    }
    
    func localizedString() -> String {
        let currentLanguage = Defaults.language
        let bundle = Bundle.main
        if let path = bundle.path(forResource: currentLanguage, ofType: "lproj"),
           let languageBundle = Bundle(path: path) {
            let localizedString = languageBundle.localizedString(forKey: self, value: nil, table: nil)
            return localizedString
        }
        
        // Fallback to main bundle if language-specific bundle is not found
        let fallbackString = NSLocalizedString(self, bundle: .main, comment: "")
        print("Fallback localization for key: \(self)")
        print("Fallback result: \(fallbackString)")
        return fallbackString
    }
}




