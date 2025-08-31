//
//  ResponseModel.swift
//  ZenModaIOS
//
//  Created by Shahruh on 11.07.2025.
//

import Foundation

struct ResponseModel<T: Codable & Equatable>: Codable, Equatable {
    var data: [T]?
    let total: Int?
    
    static func == (lhs: ResponseModel<T>, rhs: ResponseModel<T>) -> Bool {
        return lhs.data == rhs.data &&
        lhs.total == rhs.total
    }
}
