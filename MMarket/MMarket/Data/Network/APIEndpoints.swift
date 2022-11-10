//
//  APIEndpoints.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation

enum APIEndpoints {
    
    private enum Constant {
        static let baseURL = "https://openmarket.yagom-academy.kr"
        static let path = "/api/products"
    }
    
    case productList(Int, Int, String)
    case productDetail(Int)
    case productCreation(Data, String)
    case productEdition(Data, Int)
    case deleteURISearch(Data, Int)
    case productDelete(String)
}

extension APIEndpoints {
    var asEndpoint: Endpoint {
        switch self {
        case .productList(let pageNumber, let itemsPerPage, let searchValue):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: Constant.path,
                method: .get,
                queries: [
                    "page_no": pageNumber,
                    "items_per_page": itemsPerPage,
                    "search_value": searchValue
                ]
            )
        case .productDetail(let productID):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: Constant.path + "/\(productID)",
                method: .get
            )
        case .productCreation(let body, let boundary):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: Constant.path,
                method: .post,
                header: [
                    "Content-Type": "multipart/form-data; boundary=\(boundary)",
                    "identifier": UserInfo.identifier
                ],
                body: body
            )
        case .productEdition(let body, let productID):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: Constant.path + "/\(productID)",
                method: .patch,
                header: [
                    "Content-Type": "application/json",
                    "identifier": UserInfo.identifier
                ],
                body: body
            )
        case .deleteURISearch(let body, let productID):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: Constant.path + "/\(productID)/archived",
                method: .post,
                header: [
                    "Content-Type": "application/json",
                    "identifier": UserInfo.identifier
                ],
                body: body
            )
        case .productDelete(let deleteURI):
            return Endpoint(
                baseURL: Constant.baseURL,
                path: "\(deleteURI)",
                method: .delete,
                header: [
                    "identifier": UserInfo.identifier
                ]
            )
        }
    }
}
