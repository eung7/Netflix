//
//  MovieMainCollectionViewCell.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/02.
//

import UIKit
import SnapKit

class MovieMainCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieMainCollectionViewCell"
    
    var didTapInterstellarButton: (() -> Void) = {}
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_header")
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "play.fill")
        config.baseForegroundColor = .white
        button.configuration = config
        button.addTarget(self, action: #selector(didTapInterstellarButton(_:)), for: .touchUpInside)

        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .systemBackground
        
        [
            imageView, playButton
        ]
            .forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        playButton.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview().inset(16)
        }
    }
}

private extension MovieMainCollectionViewCell {
    @objc func didTapInterstellarButton(_ sender: UIButton) {
        didTapInterstellarButton()
    }
}
