//
//  APIEndpoints.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation

enum APIEndpoints {
    private enum Constant {
        static let baseURL = "https://market-training.yagom-academy.kr/"
        static let path = "api/products/"
    }
    
    case productList(Int, Int)
    case productDetail(Int)
    case productCreation(Data, String)
    case productEdition(Data, Int)
    case scretKeySearch(Data, Int)
    case productDelete(Int, String)
}

extension APIEndpoints {
    var asEndpoint: Endpoint {
        switch self {
        case .productList(let pageNumber, let itemsPerPage):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: Constant.path,
                method: .get,
                queries: [
                    "page_no": pageNumber,
                    "items_per_page": itemsPerPage
                ]
            )
        case .productDetail(let productId):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: Constant.path + "\(productId)",
                method: .get
            )
        case .productCreation(let body, let boundary):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: "/api/products",
                method: .post,
                header: [
                    "Content-Type": "multipart/form-data; boundary=\(boundary)",
                    "identifier": "8de44ec8-d1b8-11ec-9676-43acdce229f5"
                ],
                body: body
            )
        case .productEdition(let body, let productId):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: Constant.path + "\(productId)",
                method: .patch,
                header: [
                    "Content-Type": "application/json",
                    "identifier": "8de44ec8-d1b8-11ec-9676-43acdce229f5"
                ],
                body: body
            )
        case .scretKeySearch(let body, let productId):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: Constant.path + "\(productId)/secret",
                method: .patch,
                header: [
                    "Content-Type": "application/json",
                    "identifier": "8de44ec8-d1b8-11ec-9676-43acdce229f5"
                ],
                body: body
            )
        case .productDelete(let productId, let productSecret):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: Constant.path + "\(productId)/\(productSecret)",
                method: .delete
            )
        }
    }
}
