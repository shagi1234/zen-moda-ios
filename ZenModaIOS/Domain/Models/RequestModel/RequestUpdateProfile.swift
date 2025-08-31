//
//  RequestUpdateProfile.swift
//  ZenModaIOS
//
//  Created by Shahruh on 18.06.2025.
//

struct RequestUpdateProfile: Codable, RequestParameters {
    let fullname: String
    let phone_number: String
    let gender: String
}
