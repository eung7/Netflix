//
//  StarMoviesManger.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/11.
//

import Foundation

class StarMoviesManager {
    
    static let shared = StarMoviesManager()
    
    var starMovies: [Item] = [] {
        didSet {
            print(starMovies)
        }
    }
    
    func addStarMovie(item: Item) {
        starMovies.append(item)
    }
    
    func removeStarMovie(item: Item) {
        guard let index = starMovies.firstIndex(of: item) else { return }
        starMovies.remove(at: index)
    }
    
    func updateStarMovie(item: Item, isStar: Bool) {
        guard let index = starMovies.firstIndex(of: item) else { return }
        starMovies[index].isStar = isStar
    }
}
