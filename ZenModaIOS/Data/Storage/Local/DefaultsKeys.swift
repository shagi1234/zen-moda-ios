//
//  DefaultsKeys.swift
//  ZenModaIOS
//
//  Created by Shahruh on 13.06.2025.
//


//
//  DefaultsKeys.swift
//  Kredit
//
//  Created by Shahruh on 06.01.2025.
//
import Foundation

enum DefaultsKeys: String, CaseIterable {
    case token
    case phoneNumber
    case username
    case language
    
    
}

class Defaults {
    
    static var token: String {
        get { UserDefaults.standard.string(forKey: DefaultsKeys.token.rawValue) ?? "" }
        set { UserDefaults.standard.setValue(newValue, forKey: DefaultsKeys.token.rawValue) }
    }
    
    static var phoneNumber: String {
        get { UserDefaults.standard.string(forKey: DefaultsKeys.phoneNumber.rawValue) ?? "" }
        set { UserDefaults.standard.setValue(newValue, forKey: DefaultsKeys.phoneNumber.rawValue) }
    }
    
    static var language: String {
        get { UserDefaults.standard.string(forKey: DefaultsKeys.language.rawValue) ?? "" }
        set { UserDefaults.standard.setValue(newValue, forKey: DefaultsKeys.language.rawValue) }
    }
    
    static var username: String {
        get { UserDefaults.standard.string(forKey: DefaultsKeys.username.rawValue) ?? "" }
        set { UserDefaults.standard.setValue(newValue, forKey: DefaultsKeys.username.rawValue) }
    }
  
    static func getCodable<T: Codable>(_ key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    static func setCodable<T: Codable>(_ value: T?, forKey key: String) {
        if let value = value, let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
}

