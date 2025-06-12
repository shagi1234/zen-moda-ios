//
//  Network.swift
//  aydym
//
//  Created by TmCars on 13.03.2024.
//

import Foundation
import Alamofire

class Network {
    
    private static let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120
        configuration.timeoutIntervalForResource = 300
        return Session(configuration: configuration)
    }()
    
    class func perform<T: Decodable>(endpoint: EndpointProtocol, completionHandler: @escaping (Result<T, AFError>) -> Void) {
        
        let networkLogger = NetworkLogger()
        
        let request = sessionManager.request(
            endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.header,
            interceptor: networkLogger
        )
        
        print("[Requesting URL]: \(endpoint.path)")
        
        request
            .validate()
            .logResponse()
            .responseDecodable(of: T.self) { response in
                completionHandler(response.result)
            }
    }
    
    class func performString(endpoint: EndpointProtocol, completion: @escaping (Result<String, AFError>) -> Void) {
        let request = sessionManager.request(
            endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.header
        )
        
        request.responseString { response in
            completion(response.result)
        }
    }
    
    class func performFormData<T: Decodable>(endpoint: EndpointProtocol, completionHandler: @escaping (Result<T, AFError>) -> Void) {
        let request = sessionManager.request(
            endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: URLEncoding.default,  // Always use URLEncoding for form data
            headers: endpoint.header
        )
        
        request
            .validate()
            .responseDecodable(of: T.self) { response in
                completionHandler(response.result)
            }
    }
    
    class func performWithCustomPath<T: Decodable>(
        endpoint: EndpointProtocol,
        additionalPath: String,
        completionHandler: @escaping (Result<T, AFError>) -> Void
    ) {
        let networkLogger = NetworkLogger()
        
        let request = sessionManager.request(
            endpoint.path + additionalPath,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.method == .get ? URLEncoding.default : JSONEncoding.default,
            headers: endpoint.header,
            interceptor: networkLogger
        )
        
        request
            .validate()
            .logResponse()
            .responseDecodable(of: T.self) { response in
                completionHandler(response.result)
            }
    }
    
    func doStuff<T: Encodable>(payload: [String: T]) {
        
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
