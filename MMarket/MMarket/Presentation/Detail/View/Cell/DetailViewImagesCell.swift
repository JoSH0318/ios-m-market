//
//  DetailViewImagesCell.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/02.
//

import SnapKit

final class DetailViewImagesCell: UICollectionViewCell {
    
    private enum FontSize {
        static let title = 16.0
        static let body = 12.0
    }
    
    static var idenfier: String {
        return String(describing: self)
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(with imageURL: String) {
        imageView.setImage(with: imageURL)
    }
    
    private func configureLayout() {
        self.contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
