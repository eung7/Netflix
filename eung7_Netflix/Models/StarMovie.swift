//
//  StarMovie.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/21.
//

import Foundation

struct StarMovie: Codable {
    let poster: String
    let movieName: String
    let trailer: String
    var isStar: Bool
}

extension StarMovie {
    static var movies: [StarMovie] = []
}

extension StarMovie {
    mutating func updateIsStar(_ isStar: Bool) {
        self.isStar = isStar
    }
}
