//
//  PlayerViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/13.
//

import Foundation

class PlayerViewModel {
    var currentMovie: StarMovie!
    
    init(_ movie: StarMovie) {
        self.currentMovie = movie
    }
}

extension PlayerViewModel {
    var trailerURL: URL {
        return URL(string: currentMovie.trailer)!
    }
    
    var movieName: String {
        return currentMovie.movieName
    }
}

extension PlayerViewModel {
    func didTapStarbutton(_ isStar: Bool) {
        if isStar == true {
            currentMovie.updateIsStar(isStar)
            StarMovie.movies.append(currentMovie)
        } else {
            if let index = StarMovie.movies.firstIndex(where: { $0.trailer == currentMovie.trailer }) {
                StarMovie.movies.remove(at: index)
            }
        }
    }
}
