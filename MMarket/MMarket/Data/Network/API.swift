//
//  API.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation

enum API {
    private enum Constant {
        static let baseURL = "https://market-training.yagom-academy.kr/"
    }
    
    case productList(Int, Int)
    case productDetail(Int)
    case productCreation(Data, String)
    case productEdition(Data, Int)
    case scretKeySearch(Int)
    case productDelete(Int, String)
}
