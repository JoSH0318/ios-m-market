//
//  APIEndpoints.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation

enum APIEndpoints {
    private enum Constant {
        static let baseURL = "https://openmarket.yagom-academy.kr/"
        static let path = "api/products/"
        static let identifier = "a1cc0fd2-4abe-11ed-a200-e3abc55dd13d"
    }
    
    case productList(Int, Int)
    case productDetail(Int)
    case productCreation(Data, String)
    case productEdition(Data, Int)
    case secretKeyInquiry(Data, Int)
    case productDelete(String, Int)
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
                    "page_no": "\(pageNumber)",
                    "items_per_page": "\(itemsPerPage)"
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
                    "identifier": Constant.identifier
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
                    "identifier": Constant.identifier
                ],
                body: body
            )
        case .secretKeyInquiry(let body, let productId):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: Constant.path + "\(productId)/secret",
                method: .patch,
                header: [
                    "Content-Type": "application/json",
                    "identifier": Constant.identifier
                ],
                body: body
            )
        case .productDelete(let productSecret, let productId):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: Constant.path + "\(productId)/\(productSecret)",
                method: .delete
            )
        }
    }
}
