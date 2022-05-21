//
//  StarMovieManger.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/21.
//

import Foundation

class StarMovieManager {
    static let shared = StarMovieManager()
}

extension StarMovieManager {
    func verifyInStarMovies(_ selectedMovie: StarMovie) -> StarMovie {
        if let starMovie = StarMovie.movies.first(where: { $0.trailer == selectedMovie.trailer }) {
            return starMovie
        } else {
            return selectedMovie
        }
    }
    
    func saveStarMovies() {
        let userdefaults = UserDefaults.standard
        let data = try? JSONEncoder().encode(StarMovie.movies)
        userdefaults.set(data, forKey: "StarMovies")
    }
    
    func loadStarMovies() {
        let userdefaults = UserDefaults.standard
        guard let starMovies = try? JSONDecoder().decode([StarMovie].self, from: userdefaults.data(forKey: "StarMovies") ?? Data()) else { return }
        StarMovie.movies = starMovies
    }
}
