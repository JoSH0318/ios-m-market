//
//  Data.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/26.
//

import Foundation

extension Data {
    mutating func appendString(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}
