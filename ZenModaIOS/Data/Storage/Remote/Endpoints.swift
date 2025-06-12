//
//  Endpoints.swift
//  aydym
//
//  Created by TmCars on 13.03.2024.
//

import Foundation
import Alamofire

enum Endpoints {
    case login(_ loginDetails: LoginDetails)
    
}

extension Endpoints: EndpointProtocol {
    var path: String {
        switch self {
        case .login:
            return CONSTANTS.BASE_URL + "/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let params):
            return params.asParameters()
            
        default:
            return nil
        }
    }
    
    var header: HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + Defaults.token,
            "Accept-Language": Defaults.language.lowercased() != "ru" ? "tm" : "ru"
        ]
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
