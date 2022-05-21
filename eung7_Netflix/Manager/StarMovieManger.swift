//
//  StarMovieManger.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/21.
//

import Foundation

class StarMovieManager {
    static let shared = StarMovieManager()

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

extension StarMovieManager {
    func saveStarMovies() {
        let userdefaults = UserDefaults.standard
        let data = try? JSONEncoder().encode(StarMovieViewModel.starMovies)
        userdefaults.set(data, forKey: "StarMovies")
    }
    
    func loadStarMovies() {
        let userdefaults = UserDefaults.standard
        guard let starMovies = try? JSONDecoder().decode([StarMovieViewModel].self, from: userdefaults.data(forKey: "StarMovies") ?? Data()) else { return }
        StarMovieViewModel.starMovies = starMovies
    }
}
