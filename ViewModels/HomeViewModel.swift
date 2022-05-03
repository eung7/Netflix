//
//  HomeViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/02.
//

import Foundation
import UIKit

enum Section: Int, CaseIterable {
    case main
    case award
    case hot
    case my
    
    var sectionTitle: String {
        switch self {
        case .award:
            return "아카데미 호평 현황"
        case .hot:
            return "취향저격 HOT 콘텐츠"
        case .my:
            return "내가 찜한 콘텐츠"
        default:
            return ""
        }
    }
}

class HomeViewModel {
    
    func fetchMovies(type: Section) -> [DummyMovie]? {
        switch type {
        case .main:
            return nil
        case .award:
            let movies = (1..<10).map { DummyMovie(type: .award, thumbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        case .hot:
            let movies = (10..<19).map { DummyMovie(type: .hot, thumbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        case .my:
            let movies = (1..<10).map { $0 * 2 }.map { DummyMovie(type: .my, thumbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        }
    }

    var awardMovies: [DummyMovie] {
        let movies = (1..<10).map { DummyMovie(type: .award, thumbnail: UIImage(named: "img_movie_\($0)")!) }
        return movies
    }

    var hotMovies: [DummyMovie] {
        let movies = (10..<19).map { DummyMovie(type: .hot, thumbnail: UIImage(named: "img_movie_\($0)")!) }
        return movies
    }

    var myMovies: [DummyMovie] {
        let movies = (1..<10).map { $0 * 2 }.map { DummyMovie(type: .my, thumbnail: UIImage(named: "img_movie_\($0)")!) }
        return movies
    }
}
