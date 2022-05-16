//
//  SaveViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/10.
//

import Foundation

class SavedViewModel {
    
    let manager = StarMovieManager.shared

    var numberOfItemsInSection: Int {
        return manager.starMovies.count
    }
}

