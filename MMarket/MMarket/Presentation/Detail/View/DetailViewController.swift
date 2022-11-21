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
    private let disposeBag = DisposeBag()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(
                systemName: "square.and.pencil",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
            ),
            for: .normal)
        button.tintColor = UIColor.navyColor
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(
                systemName: "trash.square",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
            ),
            for: .normal)
        button.tintColor = UIColor.navyColor
        return button
    }()
    
    private let backBarButton: UIBarButtonItem = {
        let backImage = UIImage(systemName: "chevron.backward")
        let barButtonItem = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: nil,
            action: nil
        )
        barButtonItem.tintColor = UIColor.navyColor
        return barButtonItem
    }()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
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
        configureNavigationBar()
    }
    
    private func bind() {
        viewModel.productImagesURL
            .observe(on: MainScheduler.instance)
            .bind(to: detailView.imagesCollectionView.rx.items(
                cellIdentifier: DetailViewImagesCell.identifier,
                cellType: DetailViewImagesCell.self
            )) { _, item, cell in
                cell.bind(with: item)
            }
            .disposed(by: disposeBag)
        
        viewModel.productDetailInfo
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { vc, product in
                vc.detailView.setContents(with: DetailViewModelItem(by: product))
            }
            .disposed(by: disposeBag)
        
        viewModel.isPostOwner
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.configureButtonsLayout()
            }
            .disposed(by: disposeBag)
        
        backBarButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.viewModel.didTapBackButton()
            }
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                guard let product = vc.viewModel.product else { return }
                vc.viewModel.didTapEditButton(product)
            }
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.viewModel.didTapDeleteButton()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureButtonsLayout() {
        detailView.setOwnerButtons(editButton, deleteButton)
    }
}

// MARK: - NavigationBar Layout

extension DetailViewController {
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.title = "상품 정보"
        navigationController?.navigationBar.backgroundColor = .systemGray5
    }
}
