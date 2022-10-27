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
        static let body = 15.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var idenfier: String {
        return String(describing: self)
    }
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
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
        label.font = .systemFont(ofSize: FontSize.title)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body, weight: .bold)
        label.textColor = .systemRed
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body, weight: .bold)
        label.textColor = .systemGray3
        return label
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func bind(product: Product) {
        ImageDownloader.shared.requestImage(urlString: product.thumbnail) { image in
            self.thumbnailImageView.image = image
        }
        nameLabel.text = product.name
        stockLabel.text = product.stock.description
        bargainPriceLabel.text = product.bargainPrice.description
        priceLabel.text = product.price.description
        dateLabel.text = product.createdAt.description
    }
    
    private func configureLayout() {
        self.contentView.addSubview(thumbnailImageView)
        self.contentView.addSubview(totalStackView)

        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalTo(self.contentView)
            $0.trailing.equalTo(totalStackView.snp.leading)
        }
        
        totalStackView.snp.makeConstraints {
            $0.top.bottom.leading.equalTo(self.contentView)
        }
        
        priceStackView.addArrangedSubview(bargainPriceLabel)
        priceStackView.addArrangedSubview(priceLabel)
        
        totalStackView.addArrangedSubview(nameLabel)
        totalStackView.addArrangedSubview(stockLabel)
        totalStackView.addArrangedSubview(priceStackView)
        totalStackView.addArrangedSubview(dateLabel)
    }
}
