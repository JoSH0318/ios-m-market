//
//  ItemCollectionView.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/18.
//

import UIKit

class ItemCollectionView: UICollectionView {
    func configureEventBannerLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 20,
            trailing: 0
        )
        return section
    }
    
    func configureItemListLayout() -> NSCollectionLayoutSection {
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
    
    func configure() {
        guard let safeArea = self.superview?.safeAreaLayoutGuide else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(safeArea)
        }
        
        self.register(
            EventBannerCell.self,
            forCellWithReuseIdentifier: EventBannerCell.idenfier
        )
        self.register(
            ItemListCell.self,
            forCellWithReuseIdentifier: ItemListCell.idenfier
        )
    }
}
