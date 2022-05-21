//
//  PlayerViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/13.
//

import Foundation

class PlayerViewModel {
    var currentMovie: StarMovieViewModel!
    
    init(_ movie: StarMovieViewModel) {
        self.currentMovie = movie
    }
}

extension PlayerViewModel {
    func didTapStarbutton(_ isStar: Bool) {
        if isStar == true {
            currentMovie.updateIsStar(isStar)
            StarMovieViewModel.starMovies.append(currentMovie)
        } else {
            if let index = StarMovieViewModel.starMovies.firstIndex(where: { $0.trailer == currentMovie.trailer }) {
                currentMovie.updateIsStar(isStar)
                StarMovieViewModel.starMovies.remove(at: index)
            }
        }
    }
}
