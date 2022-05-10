//
//  SavedCollectionViewCell.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/10.
//

import UIKit
import SnapKit

class SavedCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SavedCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

