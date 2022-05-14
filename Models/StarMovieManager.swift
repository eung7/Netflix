//
//  StarMovieManager.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/13.
//

import Foundation

class StarMovieManager {
    
    static let shared = StarMovieManager()
    
    var starMovies: [Item] = []
    
    
    func addStarMovie(item: Item) {
        starMovies.append(item)
    }
    
    func removeStarMovie(item: Item) {
        guard let index = starMovies.firstIndex(where: { $0.trailer == item.trailer }) else { return }
        starMovies.remove(at: index)
    }
    
    func updateStarMovie(item: Item, starState: Bool) {
        guard let index = starMovies.firstIndex(where: { $0.trailer == item.trailer }) else { return }
        starMovies[index].updateStar(starState)
    }
    
    func saveStarMovies() {
        let userDefaults = UserDefaults.standard
        let encoder = PropertyListEncoder()
        let data = try? encoder.encode(starMovies)
        
        userDefaults.setValue(data, forKey: "StarMovies")
    }
    
    func loadStarMovies() {
        let userDefaults = UserDefaults.standard
        let decoder = PropertyListDecoder()
        
        if let data = userDefaults.object(forKey: "StarMovies") as? Data {
            do {
                var movies = try decoder.decode([Item].self, from: data)
                for (index, _) in movies.enumerated() {
                    movies[index].updateStar(true)
                }
                starMovies = movies
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }
}
