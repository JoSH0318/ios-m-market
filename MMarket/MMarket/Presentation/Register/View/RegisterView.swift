//
//  RegisterView.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/05.
//

import UIKit

final class RegisterView: UIView {
    
    private enum FontSize {
        static let title = 20.0
        static let body = 16.0
    }
    
    private let imageScrollView = UIScrollView()
    
    let addImageButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .darkGray
        button.backgroundColor = .systemBackground
        button.clipsToBounds = true
        return button
    }()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.keyboardType = .default
        return textField
    }()
    
    private let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["₩", "$"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setContentCompressionResistancePriority(.required, for: .horizontal)
        return segmentedControl
    }()
    
    private let priceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.keyboardType = .numberPad
        textField.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
        return textField
    }()
    
    private let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let stockTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(named: "MainGrayColor")?.cgColor
        textView.backgroundColor = .white
        textView.keyboardType = .default
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        textView.setContentHuggingPriority(.init(rawValue: 1), for: .vertical)
        return textView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        configureLayout()
        setContentsOfRegisterView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setContentsOfRegisterView() {
        nameTextField.placeholder = "글 제목"
        priceTextField.placeholder = "가격"
        discountedPriceTextField.placeholder = "할인 가격"
        stockTextField.placeholder = "재고 수량"
    }
    
    func setProductRequest() -> ProductRequest {
        var currency = "KRW"
        
        if currencySegmentedControl.selectedSegmentIndex == 1 {
            currency = "USD"
        }
        
        return ProductRequest(
            name: nameTextField.text,
            price: Int(priceTextField.text ?? ""),
            discountedPrice: Int(discountedPriceTextField.text ?? ""),
            stock: Int(stockTextField.text ?? ""),
            currency: currency,
            description: descriptionTextView.text,
            secret: "xcnbof13rg2"
        )
    }
    
    func setImages(_ image: UIImage) {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.snp.makeConstraints {
            $0.width.equalTo(imageView.snp.height)
        }
        imageStackView.addArrangedSubview(imageView)
    }
    
    func hideAddImageButton() {
        addImageButton.isHidden = true
    }
    
    private func configureLayout() {
        addSubview(mainScrollView)
        mainScrollView.addSubview(imageScrollView)
        mainScrollView.addSubview(totalStackView)
        
        imageScrollView.addSubview(imageStackView)
        imageStackView.addArrangedSubview(addImageButton)
        
        priceStackView.addArrangedSubview(priceTextField)
        priceStackView.addArrangedSubview(currencySegmentedControl)
        
        totalStackView.addArrangedSubview(imageScrollView)
        totalStackView.addArrangedSubview(nameTextField)
        totalStackView.addArrangedSubview(priceStackView)
        totalStackView.addArrangedSubview(discountedPriceTextField)
        totalStackView.addArrangedSubview(stockTextField)
        totalStackView.addArrangedSubview(descriptionTextView)
        
        mainScrollView.snp.makeConstraints {
            $0.leading.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.trailing.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        totalStackView.snp.makeConstraints {
            $0.edges.equalTo(mainScrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(mainScrollView.frameLayoutGuide)
        }
        
        imageScrollView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(self.snp.height).multipliedBy(0.17)
        }
        
        imageStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        addImageButton.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(addImageButton.snp.height)
        }
    }
}
