//
//  Network.swift
//  aydym
//
//  Created by TmCars on 13.03.2024.
//

import Foundation
import Alamofire

// MARK: - Updated Network Class
class Network {
    
    private static let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120
        configuration.timeoutIntervalForResource = 300
        return Session(configuration: configuration)
    }()
    
    class func perform<T: Decodable>(
        endpoint: EndpointProtocol,
        completionHandler: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let networkLogger = NetworkLogger()
        
        let request = sessionManager.request(
            endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.header,
            interceptor: networkLogger
        )
        
        request
            .validate()
            .logResponse()
            .responseDecodable(of: T.self) { response in
                let result = response.result.mapError { afError -> NetworkError in
                    return convertAFErrorToNetworkError(afError)
                }
                completionHandler(result)
            }
    }
    
    class func performString(
        endpoint: EndpointProtocol,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        let request = sessionManager.request(
            endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.header
        )
        
        request.responseString { response in
            let result = response.result.mapError { afError -> NetworkError in
                return convertAFErrorToNetworkError(afError)
            }
            completion(result)
        }
    }
    
    class func performWithCustomPath<T:Decodable> (endpoint: EndpointProtocol,
                                                   additionalPath: String,
                                                   completionHandler: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let networkLogger = NetworkLogger()
        
        let request = sessionManager.request(
            endpoint.path + additionalPath,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.header,
            interceptor: networkLogger
        )
        
        request
            .validate()
            .logResponse()
            .responseDecodable(of: T.self) { response in
                let result = response.result.mapError { afError -> NetworkError in
                    return convertAFErrorToNetworkError(afError)
                }
                completionHandler(result)
            }
       
    }
    
    class func performFormData<T: Decodable>(
        endpoint: EndpointProtocol,
        completionHandler: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let request = sessionManager.request(
            endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: URLEncoding.default,
            headers: endpoint.header
        )
        
        request
            .validate()
            .responseDecodable(of: T.self) { response in
                let result = response.result.mapError { afError -> NetworkError in
                    return convertAFErrorToNetworkError(afError)
                }
                completionHandler(result)
            }
    }
    
    private class func convertAFErrorToNetworkError(_ afError: AFError) -> NetworkError {
        switch afError {
        case .invalidURL:
            return .invalidURL
        case .sessionTaskFailed(let error):
            if let urlError = error as? URLError {
                switch urlError.code {
                case .timedOut:
                    return .timeout
                case .notConnectedToInternet, .networkConnectionLost:
                    return .networkFailure("No internet connection")
                default:
                    return .networkFailure(urlError.localizedDescription)
                }
            }
            return .networkFailure(error.localizedDescription)
        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(let code):
                switch code {
                case 401:
                    return .unauthorized
                case 403:
                    return .forbidden
                case 404:
                    return .notFound
                case 500...599:
                    return .serverError(code)
                default:
                    return .serverError(code)
                }
            default:
                return .networkFailure(afError.localizedDescription)
            }
        case .responseSerializationFailed:
            return .decodingError
        default:
            return .networkFailure(afError.localizedDescription)
        }
    }
}


extension Encodable {
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return nil }
        return dictionary
    }
}

class NetworkLogger: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var requestLog = "📤 REQUEST DETAILS:\n"
        requestLog += "URL: \(urlRequest.url?.absoluteString ?? "nil")\n"
        requestLog += "METHOD: \(urlRequest.httpMethod ?? "nil")\n"
        
        if let headers = urlRequest.allHTTPHeaderFields, !headers.isEmpty {
            requestLog += "HEADERS: \n"
            headers.forEach { requestLog += "  \($0.key): \($0.value)\n" }
        }
        
        if let body = urlRequest.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            requestLog += "BODY: \(bodyString)\n"
        }
        
        Logger.shared.log(Network.self, level: .DEBUG, message: requestLog)
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        Logger.shared.log(Network.self, level: .ERROR, message: "❌ REQUEST FAILED: \(error.localizedDescription)")
        completion(.doNotRetry)
    }
}

extension DataRequest {
    @discardableResult
    func logResponse() -> Self {
        return response { response in
            var responseLog = "📥 RESPONSE DETAILS:\n"
            responseLog += "URL: \(response.request?.url?.absoluteString ?? "nil")\n"
            responseLog += "STATUS CODE: \(response.response?.statusCode ?? 0)\n"
            
            if let headers = response.response?.allHeaderFields {
                responseLog += "HEADERS: \n"
                for (key, value) in headers {
                    responseLog += "  \(key): \(value)\n"
                }
            }
            
            if let data = response.data, let stringData = String(data: data, encoding: .utf8) {
                responseLog += "RESPONSE DATA: \(stringData)\n"
            }
            
            if let error = response.error {
                responseLog += "ERROR: \(error.localizedDescription)\n"
            }
            
            Logger.shared.log(Network.self, level: .DEBUG, message: responseLog)
        }
    }
}
