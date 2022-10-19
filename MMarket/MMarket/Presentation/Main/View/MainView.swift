//
//  MainView.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/18.
//

import UIKit

final class MainView: UIView {
    private lazy var productListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: configureProductListLayout()
    )
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureProductListLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.5)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
    
    private func configure() {
        guard let safeArea = self.superview?.safeAreaLayoutGuide else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(safeArea)
        }
        
        self.productListCollectionView.register(
            ProductListCell.self,
            forCellWithReuseIdentifier: ProductListCell.idenfier
        )
    }
}