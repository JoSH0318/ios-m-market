//
//  DividerLineView.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/04.
//

import UIKit

final class DividerLineView: UIView {
    init(height: CGFloat) {
        super.init(frame: .zero)
        
        configureLayout(height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout(_ height: CGFloat) {
        backgroundColor = .systemGray3
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
