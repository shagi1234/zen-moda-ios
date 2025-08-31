//
//  ResponseConfirmOtp.swift
//  ZenModaIOS
//
//  Created by Shahruh on 16.06.2025.
//

struct ResponseConfirmOtp: Codable {
    let access_token: String?
    let refresh_token: String?
    let message: String
    let userAlreadyExist: Bool
    let user: UserData?
}

struct UserData: Codable {
    let id: String
    let phone_number: String
    let fullname: String?
    let gender:String?
}
