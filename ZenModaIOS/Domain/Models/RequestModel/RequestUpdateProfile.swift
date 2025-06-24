//
//  RequestUpdateProfile.swift
//  ZenModaIOS
//
//  Created by Shahruh on 18.06.2025.
//

struct RequestUpdateProfile: Codable, RequestParameters {
    let fullname: String
    let gender: String
}
