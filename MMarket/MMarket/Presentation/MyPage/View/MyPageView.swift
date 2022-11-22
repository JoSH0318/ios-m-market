//
//  MyPageView.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/22.
//

import SnapKit

final class MyPageView: UIView {
    private(set) lazy var productListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: configureProductListLayout()
    )
    
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureProductListLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, env in
            let width = (env.container.effectiveContentSize.width) * 0.5
            let height = width * 1.4
            
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
    
    private func configureView() {
        backgroundColor = .systemBackground
        
        addSubview(productListCollectionView)
        
        productListCollectionView.register(
            ProductListCell.self,
            forCellWithReuseIdentifier: ProductListCell.identifier
        )
    }
    
    private func configureConstraints() {
        productListCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview()
        }
    }
}

