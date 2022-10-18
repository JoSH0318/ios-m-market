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

class MainViewController: UIViewController {
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

extension MainViewController {}
