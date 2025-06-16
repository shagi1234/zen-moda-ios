//
//  RequestConfirmOtp.swift
//  ZenModaIOS
//
//  Created by Shahruh on 16.06.2025.
//

struct RequestConfirmOtp: Codable,RequestParameters {
    var phoneNumber: String
    var otp: String
    var id: String
}
