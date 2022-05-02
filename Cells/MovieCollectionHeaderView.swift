//
//  MovieCollectionHeaderView.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/02.
//

import UIKit
import SnapKit

class MovieCollectionHeaderView: UICollectionReusableView {
    
    static let identifier = "MovieCollectionHeaderView"
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .heavy)
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .systemBackground
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
        }
    }
    
}
