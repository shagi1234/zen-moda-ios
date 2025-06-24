//
//  Endpoints.swift
//  aydym
//
//  Created by TmCars on 13.03.2024.
//

import Foundation
import Alamofire

enum Endpoints {
    case login(_ request: RequestLogin)
    case confirmOtp(_ request: RequestConfirmOtp)
    case updateProfile(_ request: RequestUpdateProfile)
    case getUser
    
}

extension Endpoints: EndpointProtocol {
    var path: String {
        switch self {
        case .login:
            return CONSTANTS.BASE_URL + "/api/auth/login"
            
        case .confirmOtp:
            return CONSTANTS.BASE_URL + "/api/auth/confirm-otp"
        case .updateProfile:
            return CONSTANTS.BASE_URL + "/api/auth/update-profile"
        case .getUser:
            return CONSTANTS.BASE_URL + "/api/user"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login,
                .confirmOtp,
                .updateProfile:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let params):
            return params.asParameters()
        case .confirmOtp(let params):
            return params.asParameters()
        case .updateProfile(let params):
            return params.asParameters()
            
        default:
            return nil
        }
    }
    
    var header: HTTPHeaders {
        if Defaults.token.isEmpty {
            return [
                "Content-Type": "application/json",
                //            "Accept-Language": Defaults.language.lowercased() != "ru" ? "tm" : "ru"
            ]
        } else {
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer " + Defaults.token,
                //            "Accept-Language": Defaults.language.lowercased() != "ru" ? "tm" : "ru"
            ]
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
