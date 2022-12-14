//
//  Endpoint.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/21.
//

import Foundation

final class Endpoint {
    private let baseURL: String
    private let path: String
    private let method: HTTPMethod
    private let header: [String: String]
    private let queries: [String: Any]
    private let body: Data?
    
    init(
        baseURL: String,
        path: String,
        method: HTTPMethod,
        header: [String : String] = [:],
        queries: [String : Any] = [:],
        body: Data? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.header = header
        self.queries = queries
        self.body = body
    }
    
    func generateRequest() throws -> URLRequest {
        let url = try generateURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.description
        
        header.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if method == .post || method == .patch,
           let body = body {
            urlRequest.httpBody = body
        }
        
        return urlRequest
    }
    
    private func generateURL() throws -> URL {
        let urlString = baseURL + path
        
        var component = URLComponents(string: urlString)
        component?.queryItems = queries.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        
        guard let url = component?.url else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
}
