//
//  ProductListCell.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/18.
//

import SnapKit

class ProductListCell: UICollectionViewCell {
    
    private enum FontSize {
        static let title = 16.0
        static let body = 12.0
    }
    
    private var viewModel: ProductListCellViewModel?
    static var idenfier: String {
        return String(describing: self)
    }
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.title, weight: .bold)
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.textColor = .systemGray3
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.title, weight: .bold)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.textColor = .systemGray3
        return label
    }()
    
    private let discountedPercentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.textColor = .systemGray3
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body, weight: .bold)
        label.textColor = .systemGray3
        return label
    }()
    
    private let discountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.spacing = 4
        return stackView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: ProductListCellViewModel) {
        thumbnailImageView.setImage(with: viewModel.thumbnailURL)
        nameLabel.text = viewModel.name
        stockLabel.text = viewModel.stock
        discountedPercentLabel.text = viewModel.discountedPercent
        priceLabel.attributedText = viewModel.price.strikeThrough()
        bargainPriceLabel.text = viewModel.bargainPrice
        dateLabel.text = viewModel.date
    }
    
    private func configureLayout() {
        self.contentView.addSubview(thumbnailImageView)
        self.contentView.addSubview(totalStackView)

        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.trailing.equalTo(totalStackView.snp.leading).offset(-16)
            $0.width.equalTo(thumbnailImageView.snp.height)
        }
        
        totalStackView.snp.makeConstraints {
            $0.top.equalTo(self.contentView).offset(24)
            $0.bottom.equalTo(self.contentView).offset(-24)
            $0.trailing.equalTo(self.contentView).offset(-16)
        }
        
        discountStackView.addArrangedSubview(discountedPercentLabel)
        discountStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(discountStackView)
        priceStackView.addArrangedSubview(bargainPriceLabel)
        
        totalStackView.addArrangedSubview(nameLabel)
        totalStackView.addArrangedSubview(priceStackView)
        totalStackView.addArrangedSubview(stockLabel)
        totalStackView.addArrangedSubview(dateLabel)
    }
}
