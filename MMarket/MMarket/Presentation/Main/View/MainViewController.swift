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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
