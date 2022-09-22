//
//  VendorDTO.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation

struct VendorDTO: Decodable {
    let name: String
    let id: Int
    let createdAt: String
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case name, id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}