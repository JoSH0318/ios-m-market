//
//  ProductUpdateView.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/05.
//

import UIKit

final class ProductUpdateView: UIView {
    
    private enum FontSize {
        static let title = 20.0
        static let body = 16.0
    }
    
    private let imageScrollView = UIScrollView()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        return stackView
    }()
    
    private let nameStackView = UIStackView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.text = "상품명"
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.keyboardType = .default
        return textField
    }()
    
    private let currencyStackView = UIStackView()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.text = "가격 단위"
        return label
    }()
    
    private let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["₩", "$"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setContentCompressionResistancePriority(.required, for: .horizontal)
        return segmentedControl
    }()
    
    private let priceStackView = UIStackView()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.text = "상품 원가"
        label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
        return label
    }()
    
    private let priceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let discountedPriceStackView = UIStackView()
    
    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.text = "상품 판매가"
        label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
        return label
    }()
    
    private let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let stockStackView = UIStackView()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.text = "재고수량"
        label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
        return label
    }()
    
    private let stockTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.text = "상품 상세 정보"
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.backgroundColor = .white
        textView.keyboardType = .default
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        textView.setContentHuggingPriority(.init(rawValue: 1), for: .vertical)
        return textView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProductRequest() -> ProductRequest {
        let currency = currencySegmentedControl.selectedSegmentIndex == 0 ? "KRW" : "USD"
        
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
    
    func setContents(by product: Product) {
        nameTextField.text = product.name
        priceTextField.text = formattedString(from: product.price)
        discountedPriceTextField.text = formattedString(from: product.discountedPrice)
        stockTextField.text = String(product.stock)
        descriptionTextView.text = product.description
        currencySegmentedControl.selectedSegmentIndex = product.currency == "KRW" ? 0 : 1
    }
    
    func setImages(_ image: UIImage) {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(named: "MainGrayColor")?.cgColor
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.snp.makeConstraints {
            $0.width.equalTo(imageView.snp.height)
        }
        imageStackView.addArrangedSubview(imageView)
    }
    
    func setAddButton(_ addImageButton: UIButton) {
        imageStackView.addArrangedSubview(addImageButton)
    }
    
    private func configureView() {
        addSubview(mainScrollView)
        mainScrollView.addSubview(imageScrollView)
        mainScrollView.addSubview(mainStackView)
        
        imageScrollView.addSubview(imageStackView)
        
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameTextField)
        
        currencyStackView.addArrangedSubview(currencyLabel)
        currencyStackView.addArrangedSubview(currencySegmentedControl)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceTextField)
        
        discountedPriceStackView.addArrangedSubview(discountedPriceLabel)
        discountedPriceStackView.addArrangedSubview(discountedPriceTextField)
        
        stockStackView.addArrangedSubview(stockLabel)
        stockStackView.addArrangedSubview(stockTextField)
        
        mainStackView.addArrangedSubview(imageScrollView)
        mainStackView.addArrangedSubview(DividerLineView())
        mainStackView.addArrangedSubview(nameStackView)
        mainStackView.addArrangedSubview(currencyStackView)
        mainStackView.addArrangedSubview(priceStackView)
        mainStackView.addArrangedSubview(discountedPriceStackView)
        mainStackView.addArrangedSubview(stockStackView)
        mainStackView.addArrangedSubview(DividerLineView())
        mainStackView.addArrangedSubview(descriptionLabel)
        mainStackView.addArrangedSubview(descriptionTextView)
    }
    
    private func configureConstraints() {
        mainScrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalTo(mainScrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(mainScrollView.frameLayoutGuide)
        }
        
        imageScrollView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(self.snp.height).multipliedBy(0.1)
        }
        
        imageStackView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
            $0.height.equalToSuperview().offset(-16)
        }
        
        nameTextField.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
        currencySegmentedControl.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
        priceTextField.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
        discountedPriceTextField.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
        stockTextField.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    private func formattedString(from number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        guard let numberString = formatter.string(from: number as NSNumber) else {
            return ""
        }
        
        return numberString
    }
}
