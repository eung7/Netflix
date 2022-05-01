//
//  MovieCollectionViewCell.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/01.
//

import UIKit
import SnapKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
    
    let movieImage: UIImageView = {
        let imageView =  UIImageView()
        imageView.backgroundColor = .systemBlue
        
        return imageView
    }()
    
    func setupUI() {
        contentView.addSubview(movieImage)
        
        movieImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

