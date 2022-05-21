//
//  StarMovieViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/20.
//

import Foundation

struct StarMovieViewModel: Codable {
    static var starMovies: [StarMovieViewModel] = [] {
        didSet {
            StarMovieManager.shared.saveStarMovies()
        }
    }
    
    let poster: String
    let movieName: String
    let trailer: String
    var isStar: Bool
}

extension StarMovieViewModel {
    mutating func updateIsStar(_ isStar: Bool) {
        self.isStar = isStar
    }
}
