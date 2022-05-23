//
//  SearchViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/04.
//

import Foundation
import UIKit

class SearchViewModel {
    var movies: [StarMovie] = []
    var toUpdate: () -> Void = {}
}

extension SearchViewModel {
    var numberOfItemsInSection: Int { return movies.count }
    func getPosterURL(_ index: Int) -> URL { return URL(string: movies[index].poster)! }
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
}
