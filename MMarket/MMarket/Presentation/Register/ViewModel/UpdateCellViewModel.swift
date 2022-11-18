//
//  UpdateCellViewModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/16.
//

import UIKit
import RxSwift
import RxRelay

protocol UpdateImageCellModelInput {}

protocol UpdateImageCellModelOutput {
    var productImage: Observable<UIImage> { get }
}

protocol UpdateImageCellModelType: UpdateImageCellModelInput, UpdateImageCellModelOutput {}
