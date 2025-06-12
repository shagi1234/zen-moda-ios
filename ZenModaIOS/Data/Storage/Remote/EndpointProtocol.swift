//
//  EndpointProtocol.swift
//  aydym
//
//  Created by TmCars on 13.03.2024.
//

import Foundation
import Alamofire

protocol EndpointProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var header: HTTPHeaders { get }
    var encoding: ParameterEncoding { get }
    var timeout: TimeInterval { get }
}

extension EndpointProtocol {
    var timeout: TimeInterval { return 30 }
    var method: HTTPMethod { return .get }
    var parameters: Parameters? { return nil }
    var header: HTTPHeaders {
        return [
            "Content-Type": method == .post ? "application/x-www-form-urlencoded" : "application/json",
            "Authorization": "Bearer " + Defaults.token,
            "Accept-Language": Defaults.language.lowercased() != "ru" ? "tm" : "ru",
            "Accept": "application/json"
        ]
    }
    var encoding: ParameterEncoding {
        switch method {
        case .post:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}

extension EndpointProtocol {
    var timeoutInterval: TimeInterval {
        return 30
    }
}

protocol RequestParameters {
    func asParameters() -> Parameters?
}

extension RequestParameters where Self: Encodable {
    func asParameters() -> Parameters? {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Parameters else {
            return nil
        }
        return dictionary
    }
}

extension AFError {
    var responseCode: Int {
        switch self {
        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(let code):
                return code
            default:
                return 500
            }
        default:
            return 500
        }
    }
}
