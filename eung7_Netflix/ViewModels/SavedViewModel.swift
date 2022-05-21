//
//  SaveViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/10.
//

import Foundation

class SaveViewModel {
    var numberOfItemsInSection: Int {
        return StarMovieViewModel.starMovies.count
    }
}

extension SaveViewModel {
    func getThumbnailURL(_ index: Int) -> URL {
        return URL(string: StarMovieViewModel.starMovies[index].poster)!
    }
}
