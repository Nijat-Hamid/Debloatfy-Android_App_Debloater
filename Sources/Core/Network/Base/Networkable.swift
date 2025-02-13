//
//  Networkable.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/13/25.
//

import Combine
import Foundation

protocol Networkable {
    func sendRequest<T: Decodable>(endpoint: EndPoint, type: T.Type) -> AnyPublisher<T, NetworkError>
}

class NetworkService: Networkable {
    
    public func sendRequest<T>(endpoint: EndPoint, type: T.Type) -> AnyPublisher<T, NetworkError> where T: Decodable {
        guard let urlRequest = createRequest(endPoint: endpoint) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.invalidURL
                }
                
                switch response.statusCode {
                case 200...299:
                    return data
                case 400:
                    throw NetworkError.badRequest
                case 401:
                    throw NetworkError.unauthorized
                case 403:
                    throw NetworkError.forbidden
                case 404:
                    throw NetworkError.noResponse
                case 500...599:
                    throw NetworkError.server
                default:
                    throw NetworkError.unknown
                }
                
            }
            .tryMap { data -> T in
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw NetworkError.decode
                }
            }
            .mapError { error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                }
                
                switch error {
                case URLError.notConnectedToInternet:
                    return NetworkError.noConnection
                case URLError.timedOut:
                    return NetworkError.timeout
                default:
                    return NetworkError.unknown
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public init() {}
}

extension Networkable {
    fileprivate func createRequest(endPoint: EndPoint) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        // Adding query parameters
        urlComponents.queryItems = endPoint.queryParams?.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        // Handling path parameters
        var path = endPoint.path
        for (key, value) in endPoint.pathParams ?? [:] {
            path = path.replacingOccurrences(of: "{\(key)}", with: value)
        }
        urlComponents.path = path
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.header
        if let body = endPoint.body {
            let encoder = JSONEncoder()
            request.httpBody = try? encoder.encode(body)
        }
        return request
    }
}
