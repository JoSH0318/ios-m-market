//
//  RegisterViewController.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/05.
//

import SnapKit
import RxSwift
import RxCocoa

final class RegisterViewController: UIViewController {
    
    private let addImageButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor(named: "MainGrayColor")?.cgColor
        button.setBackgroundImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = UIColor(named: "MainGrayColor")
        button.backgroundColor = .systemBackground
        button.clipsToBounds = true
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
    
    private let registerView = ProductUpdateView()
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
        configureView()
        bind()
        imagePicker.delegate = self
    }
    
    private func bind() {
        backBarButton.rx.tap
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { vc, _ in
                vc.coordinator.popRegisterView()
            }
            .disposed(by: disposeBag)
        
        completionBarButton.rx.tap
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { vc, _ in
                let productRequest = vc.registerView.setProductRequest()
                let imagesData = vc.viewModel.productImages
                vc.viewModel.didTapPostButton(productRequest, images: imagesData)
            }
            .disposed(by: disposeBag)
        
        addImageButton.rx.tap
            .withUnretained(self)
            .filter { vc, _ in
                vc.viewModel.imagesCount < 5
            }
            .bind { vc, _ in
                vc.coordinator.showPhotoLibrary(to: vc.imagePicker)
            }
            .disposed(by: disposeBag)
        
        viewModel.postProdct
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.coordinator.showAlert(with: "제품을 등록했습니다.")
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .withUnretained(self)
            .subscribe(onNext: { vc, error in
                vc.coordinator.showErrorAlert()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - NavigationBar Layout

extension RegisterViewController {
    private func configureView() {
        registerView.setAddButton(addImageButton)
        addImageButton.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(addImageButton.snp.height)
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = completionBarButton
        navigationItem.title = "상품 등록하기"
        navigationController?.navigationBar.backgroundColor = .systemGray5
    }
}

//MARK: - ImagePickerController

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            guard let resizedPickerImage = resize(image: image, newWidth: 300) else { return }
            
            registerView.setImages(image)
            viewModel.selectImage(resizedPickerImage)
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
