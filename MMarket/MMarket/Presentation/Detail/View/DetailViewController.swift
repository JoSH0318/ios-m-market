//
//  DetailViewController.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/02.
//

import UIKit
import RxSwift

final class DetailViewController: UIViewController {
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "MainNavyColor")
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "MainNavyColor")
        return button
    }()
    
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
        
        bind()
    }
    
    private func bind() {
        viewModel.productImagesURL
            .observe(on: MainScheduler.instance)
            .bind(to: detailView.imagesCollectionView.rx.items(
                cellIdentifier: DetailViewImagesCell.idenfier,
                cellType: DetailViewImagesCell.self
            )) { _, item, cell in
                cell.setImage(with: item)
            }
            .disposed(by: disposeBag)
        
        viewModel.productDetailInfo
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { vc, product in
                vc.detailView.setContents(with: DetailViewModelItem(by: product))
            }
            .disposed(by: disposeBag)
    }
}
