//
//  EventBannerCell.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/17.
//

import SnapKit

class EventBannerCell: UICollectionViewCell {
    static var idenfier: String {
        return String(describing: self)
    }
    
    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let eventImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func bind(image: UIImage) {
        eventImageView.image = image
        configure()
    }
    
    private func configure() {
        contentView.addSubview(eventImageStackView)
        eventImageStackView.addArrangedSubview(eventImageView)
        
        eventImageStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.contentView)
        }
    }
}
