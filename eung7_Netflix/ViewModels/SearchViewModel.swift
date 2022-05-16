//
//  SearchViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/04.
//

import Foundation
import Alamofire
import CoreMedia

class SearchViewModel {
    
    let manager = StarMovieManager.shared
    
    var items: [Item] = []
    
    var numberOfItems: Int {
        return items.count
    }
}
