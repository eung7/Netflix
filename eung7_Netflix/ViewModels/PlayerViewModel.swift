//
//  PlayerViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/13.
//

import Foundation

class PlayerViewModel {
    
    func didTapStarButton(item: Item, starState: Bool) {
        let manager = StarMovieManager.shared
        
        if starState {
            manager.addStarMovie(item: item)
            manager.updateStarMovie(item: item, starState: starState)
        } else {
            manager.removeStarMovie(item: item)
            manager.updateStarMovie(item: item, starState: starState)
        }
        
        manager.saveStarMovies()
        print(manager.starMovies)
    }
}

