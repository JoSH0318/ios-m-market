//
//  EditViewController.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/08.
//

import UIKit
import RxSwift
import RxCocoa

class EditViewController: UIViewController {
    private let editView = ProductUpdateView(.edit)
    private var viewModel: EditViewModel
    private var coordinator: EditCoordinator
    private let disposeBag = DisposeBag()
    
    private let backBarButton: UIBarButtonItem = {
        let backImage = UIImage(systemName: "chevron.backward")
        let barButtonItem = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: nil,
            action: nil
        )
        barButtonItem.tintColor = .darkGray
        return barButtonItem
    }()
    
    private let saveBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: nil,
            style: .plain,
            target: nil,
            action: nil
        )
        barButtonItem.title = "저장"
        barButtonItem.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)],
            for: .normal
        )
        barButtonItem.tintColor = UIColor(named: "MainBeigeColor")
        return barButtonItem
    }()
    
    init(
        viewModel: EditViewModel,
        coordinator: EditCoordinator
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.didLaunchView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = editView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        bind()
        setContents()
    }
    
    private func bind() {
        viewModel.imageURL
            .bind(to: editView.imageCollectionView.rx.items(
                cellIdentifier: UpdateImagesCell.identifier,
                cellType: UpdateImagesCell.self
            )) { _, item, cell in
                cell.bind(with: item)
            }
            .disposed(by: disposeBag)
        
        backBarButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.coordinator.popEditView()
            }
            .disposed(by: disposeBag)
        
        saveBarButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                let productRequest = vc.editView.setProductRequest()
                vc.viewModel.didTapSaveButton(productRequest)
            }
            .disposed(by: disposeBag)
    }
    
    private func setContents() {
        editView.setContents(by: viewModel.product)
    }
}

extension EditViewController {
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = saveBarButton
        navigationItem.title = "상품 수정하기"
        navigationController?.navigationBar.backgroundColor = .systemGray5
    }
}
