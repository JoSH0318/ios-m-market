//
//  RegisterViewController.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/05.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

final class RegisterViewController: UIViewController {
    
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

    private let completionBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: nil,
            style: .plain,
            target: nil,
            action: nil
        )
        barButtonItem.title = "완료"
        barButtonItem.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)],
            for: .normal
        )
        barButtonItem.tintColor = UIColor(named: "MainBeigeColor")
        return barButtonItem
    }()
    
    private let imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    private let registerView = RegisterView()
    private var viewModel: RegisterViewModel
    private var coordinator: RegisterCoordinator
    private let disposeBag = DisposeBag()
    
    init(
        viewModel: RegisterViewModel,
        coordinator: RegisterCoordinator
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        bind()
        imagePicker.delegate = self
    }
    
    private func bind() {
        backBarButton.rx.tap
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { vc, _ in
                vc.coordinator.removeRegisterView()
            })
            .disposed(by: disposeBag)
        
        completionBarButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                let productRequest = vc.registerView.setProductRequest()
                let imagesData = vc.viewModel.productImages
                vc.viewModel.didTapPostButton(productRequest, images: imagesData)
            })
            .disposed(by: disposeBag)
        
        registerView.addImageButton.rx.tap
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { vc, _ in
                vc.coordinator.showPhotoLibrary(to: vc.imagePicker)
            })
            .disposed(by: disposeBag)
        
        viewModel.postProdct
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { vc, _ in
                vc.coordinator.showAlert(with: "제품을 등록했습니다.")
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { vc, error in
                vc.coordinator.showErrorAlert()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - NavigationBar Layout

extension RegisterViewController {
    private func configureLayout() {}
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = completionBarButton
        navigationItem.title = "M-Market"
        navigationController?.navigationBar.backgroundColor = .systemGray5
    }
}

//MARK: - ImagePickerController

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func presentAlbum() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: false, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            guard let resizedPickerImage = resize(image: image, newWidth: 300) else {
                return
            }
            registerView.setImages(image)
            viewModel.selectImage(resizedPickerImage)
        }
        if viewModel.imagesCount == 5 {
            registerView.hideAddImageButton()
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func resize(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
