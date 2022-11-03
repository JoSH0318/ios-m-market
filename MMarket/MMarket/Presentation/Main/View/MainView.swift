//
//  MainView.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/18.
//

import SnapKit

final class MainView: UIView {
    private(set) lazy var productListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: configureProductListLayout()
    )
    
    init() {
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureProductListLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, env in
            let width = (env.container.effectiveContentSize.width) * 0.5
            let height = width * 1.5
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(width),
                heightDimension: .absolute(height)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(height)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
    
    private func configureLayout() {
        addSubview(productListCollectionView)
        
        productListCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        productListCollectionView.register(
            ProductListCell.self,
            forCellWithReuseIdentifier: ProductListCell.idenfier
        )
    }
}
