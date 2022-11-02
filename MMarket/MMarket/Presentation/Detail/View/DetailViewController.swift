//
//  DetailViewController.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/02.
//

import UIKit
import RxSwift

final class DetailViewController: UIViewController {
    private let detailView = DetailView()
    private var viewModel: DetailViewModel
    private var coordinator: DetailCoordinator
    private let disposeBag = DisposeBag()
    
    init(
        viewModel: DetailViewModel,
        coordinator: DetailCoordinator
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
