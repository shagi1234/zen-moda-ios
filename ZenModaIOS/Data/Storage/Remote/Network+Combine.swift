import Foundation
import Combine
import Alamofire

extension Network {
    static var shared = Network()
    
    func request<T: Decodable>(endpoint: EndpointProtocol) -> AnyPublisher<T, Error> {
        let request = AF.request(
            endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.header
        )
        
        return request
            .validate()
            .publishDecodable(type: T.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func requestWithCustomPath<T: Decodable>(endpoint: EndpointProtocol, additionalPath: String) -> AnyPublisher<T, Error> {
        let request = AF.request(
            endpoint.path + additionalPath,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.method == .get ? URLEncoding.default : JSONEncoding.default,
            headers: endpoint.header
        )
        
        return request
            .validate()
            .publishDecodable(type: T.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
} 