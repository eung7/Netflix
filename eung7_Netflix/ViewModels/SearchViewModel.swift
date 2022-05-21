//
//  SearchViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/04.
//

import Foundation

class SearchViewModel {
    var movies: [StarMovieViewModel] = []
}

extension SearchViewModel {
    func createStarMovie(_ movie: Movie, isStar: Bool) -> StarMovieViewModel {
        return StarMovieViewModel(poster: movie.poster, movieName: movie.movieName, trailer: movie.trailer, isStar: false)
    }
    
    func verifyInStarMovies(_ selectedMovie: StarMovieViewModel) -> StarMovieViewModel {
        if let starMovie = StarMovieViewModel.starMovies.first(where: { $0.trailer == selectedMovie.trailer }) {
            return starMovie
        } else {
            return selectedMovie
        }
    }
}
