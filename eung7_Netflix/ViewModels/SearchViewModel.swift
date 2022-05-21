//
//  SearchViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/04.
//

import Foundation

class SearchViewModel {
    var toUpdate: () -> Void = {}
    var movies: [StarMovie] = []
}

extension SearchViewModel {
    var numberOfItemsInSection: Int {
        return movies.count
    }
}

extension SearchViewModel {
    func fetchMovies(_ from: String) {
        Service.fetchStarMovies(from) { [weak self] starMovies in
            DispatchQueue.main.async {
                self?.movies = starMovies
                self?.toUpdate()
            }
        }
    }
    
    func getPosterURL(_ index: Int) -> URL {
        return URL(string: movies[index].poster)!
    }
}
