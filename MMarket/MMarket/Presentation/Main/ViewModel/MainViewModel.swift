//
//  MainViewModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/27.
//

import Foundation

struct MainViewModel {
    private let productUseCase: ProductUseCase
    
    init(productUseCase: ProductUseCase) {
        self.productUseCase = productUseCase
    }
}
