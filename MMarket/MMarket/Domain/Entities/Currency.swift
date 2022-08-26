//
//  Currency.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/25.
//

import Foundation

enum Currency: String, Codable {
    case won = "KRW"
    case dollar = "USD"
    
    var text: String {
        return self.rawValue
    }
    
    var optionNumber: Int {
        switch self {
        case .won:
            return 0
        case .dollar:
            return 1
        }
    }
}
