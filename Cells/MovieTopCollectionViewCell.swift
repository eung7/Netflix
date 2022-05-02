//
//  MovieTopHeaderView.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/02.
//

import UIKit
import SnapKit

class MovieTopCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieTopCollectionViewCell"
    
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
        config.baseForegroundColor = .systemBackground
        button.configuration = config

        return button
    }()
    
    let infoButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "info.circle")
        config.baseForegroundColor = .systemBackground
        button.configuration = config
        
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .systemBackground
        
        [
            imageView, playButton, infoButton
        ]
            .forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        playButton.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview().inset(16)
        }
        
        infoButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(16)
        }
    }
}

