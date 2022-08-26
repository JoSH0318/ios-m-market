//
//  MainViewController.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/16.
//

import UIKit

class MainViewController: UIViewController {
    
    enum Section: CaseIterable {
        case eventBanner
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Page>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Page>
    private lazy var dataSource = makeDataSource()
    
    private let itemCollectionView = ItemCollectionView()
    private var pages = [Page]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
