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

struct Item: Codable {
    let trailer: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case trailer = "previewUrl"
        case poster = "artworkUrl100"
    }
}
