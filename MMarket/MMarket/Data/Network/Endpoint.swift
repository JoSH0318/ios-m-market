//
//  Endpoint.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/21.
//

import Foundation

final class Endpoint {
    private let baseUrl: String
    private let path: String
    private let method: String
    private let header: [String: String]
    private let queries: [String: Any]
    private let body: Data?
    
    init(
        baseUrl: String,
        path: String,
        method: String,
        header: [String : String],
        queries: [String : Any],
        body: Data?
    ) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.header = header
        self.queries = queries
        self.body = body
    }
}
