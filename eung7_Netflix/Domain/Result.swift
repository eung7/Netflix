//
//  Movie.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/04.
//

import Foundation

struct Result: Codable {
    let results: [Item]
}

struct Item: Codable, Equatable {
    let trailer: String
    let poster: String
    let movieName: String
    var isStar: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case trailer = "previewUrl"
        case poster = "artworkUrl100"
        case movieName = "trackName"
    }
    
    mutating func updateStar(_ isStar: Bool) {
        self.isStar = isStar
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.trailer == rhs.trailer
    }
}
