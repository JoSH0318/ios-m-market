//
//  VendorDTO.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation

struct VendorDTO: Codable, Equatable {
    let name: String
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case name, id
    }
}

extension VendorDTO {
    func toEntity() -> Vendor {
        let entity = Vendor(
            name: self.name,
            id: self.id
        )
        
        return entity
    }
}
