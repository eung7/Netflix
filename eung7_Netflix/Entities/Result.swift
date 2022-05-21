//
//  Movie.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/21.
//

import Foundation

struct Result: Codable {
    let results: [Movie]
}

struct Movie: Codable, Equatable {
    let trailer: String
    let poster: String
    let movieName: String
    
    enum CodingKeys: String, CodingKey {
        case trailer = "previewUrl"
        case poster = "artworkUrl100"
        case movieName = "trackName"
    }
}
