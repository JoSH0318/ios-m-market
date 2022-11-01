//
//  CALayer.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/01.
//

import UIKit

extension CALayer {
    func addBottomBorder() {
        let border = CALayer()
        let borderWidth = 0.5
        border.frame = CGRect(x: 10, y: frame.height - borderWidth,
                              width: frame.width, height: borderWidth)
        border.backgroundColor = UIColor.lightGray.cgColor
        self.addSublayer(border)
    }
}

