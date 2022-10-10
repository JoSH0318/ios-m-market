//
//  MainViewController.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/16.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources

class MainViewController: UIViewController {
    
    enum Section: CaseIterable {
        case eventBanner
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Product>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Product>
    private lazy var dataSource = makeDataSource()
    
    private let itemCollectionView = ItemCollectionView()
    private var pages = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Layout

extension MainViewController {
    private func configureLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {(
            sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection? in
            let sectionLayoutKind = Section.allCases[sectionIndex]
            
            switch (sectionLayoutKind) {
            case .eventBanner:
                return self.itemCollectionView.configureEventBannerLayout()
            case .main:
                return self.itemCollectionView.configureItemListLayout()
            }
        }
        return layout
    }
}

// MARK: - DataSource

extension MainViewController {
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: itemCollectionView
        ) { collectionView, indexPath, itemIdentifier in
            let sectionType = Section.allCases[indexPath.section]
            
            switch sectionType {
            case .eventBanner:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EventBannerCell.idenfier,
                    for: indexPath
                ) as? EventBannerCell else {
                    return nil
                }
                return cell
            case .main:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ItemListCell.idenfier,
                    for: indexPath
                ) as? ItemListCell else {
                    return nil
                }
                return cell
            }
        }
        return dataSource
    }
}

// MARK: - SnapShot

extension MainViewController {
    private func applySnapShot() {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(pages)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}
