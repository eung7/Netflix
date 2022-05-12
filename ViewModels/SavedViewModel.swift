//
//  SaveViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/10.
//

import Foundation

class SavedViewModel {
    
    static let shared = SavedViewModel()
    
    static var movies: [Item] = []
    
    var numberOfItemsInSection: Int {
        return SavedViewModel.movies.count
    }
    
    func addStarMovie(item: Item) {
        SavedViewModel.movies.append(item)
    }
    
    func removeStarMovie(item: Item) {
        guard let index = SavedViewModel.movies.firstIndex(of: item) else { return }
        SavedViewModel.movies.remove(at: index)
    }

}
