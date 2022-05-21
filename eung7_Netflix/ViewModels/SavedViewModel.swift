//
//  SaveViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/10.
//

import Foundation

class SaveViewModel {
    var numberOfItemsInSection: Int {
        return StarMovie.movies.count
    }
}

extension SaveViewModel {
    func getThumbnailURL(_ index: Int) -> URL {
        return URL(string: StarMovie.movies[index].poster)!
    }
    
    func verifyInStarMovies(_ movie: StarMovie) -> StarMovie {
        if let starMovie = StarMovie.movies.first(where: { $0.trailer == movie.trailer }) {
            return starMovie
        } else {
            return movie
        }
    }

}
