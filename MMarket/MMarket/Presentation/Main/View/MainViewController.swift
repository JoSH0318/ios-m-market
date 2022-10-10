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
    private typealias DataSource = RxCollectionViewSectionedReloadDataSource<ProductSectionModel>
    
    private lazy var dataSource = generateDataSource()
    
    private let itemCollectionView = ProductCollectionView()
    private var pages = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Layout

extension MainViewController {
    private func configureLayout() {}
}

// MARK: - DataSource

extension MainViewController {
    private func generateDataSource() -> DataSource {
        return DataSource { dataSource, collectionView, indexPath, item in
            switch dataSource[indexPath] {
            case .eventBannerItem(image: let image):
                guard let cell: EventBannerCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EventBannerCell.idenfier,
                    for: indexPath
                ) as? EventBannerCell else {
                    return UICollectionViewCell()
                }
                cell.bind(image: image)
                
                return cell
            case .productListItem(product: let product):
                guard let cell: ProductListCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductListCell.idenfier,
                    for: indexPath
                ) as? ProductListCell else {
                    return UICollectionViewCell()
                }
                cell.bind(product: product)
                
                return cell
            }
        }
    }
}
