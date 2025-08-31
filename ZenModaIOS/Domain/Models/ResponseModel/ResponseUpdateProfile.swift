//
//  ResponseUpdateProfile.swift
//  ZenModaIOS
//
//  Created by Shahruh on 18.06.2025.
//

struct ResponseUpdateProfile: Codable {
    let access_token: String
    let refresh_token: String
    let message: String
    let user: UserData
}
