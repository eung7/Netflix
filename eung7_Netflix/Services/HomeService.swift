//
//  DummyMovieService.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/21.
//

import Foundation
import UIKit

enum Section: Int, CaseIterable {
    case award
    case hot
    case my
}

class HomeService {
    static func fetchMovies(_ type: Section, completion: @escaping ([DummyMovie]) -> Void) {
        switch type {
        case .award:
            let movies = (1..<10).map { DummyMovie(type: .award, thumbnail: UIImage(named: "img_movie_\($0)")!) }
            completion(movies)
        case .hot:
            let movies = (10..<19).map { DummyMovie(type: .hot, thumbnail: UIImage(named: "img_movie_\($0)")!) }
            completion(movies)
        case .my:
            let movies = (1..<10).map { $0 * 2 }.map { DummyMovie(type: .my, thumbnail: UIImage(named: "img_movie_\($0)")!) }
            completion(movies)
        }
    }
    
}
