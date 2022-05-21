//
//  ServiceAPI.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/16.
//

import Foundation
import Alamofire

/// Repository를 이용해 Entity -> Model로 변형
class Service {
    static func fetchStarMovies(_ from: String, completion: @escaping ([StarMovie]) -> Void) {
        Repository.fetchMovies(from: from) { movies in
            let starMovies = movies.map { return StarMovie(poster: $0.poster, movieName: $0.movieName, trailer: $0.trailer, isStar: false)}
            DispatchQueue.main.async {
                completion(starMovies)
            }
        }
    }
}
