//
//  HomeViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/02.
//

import Foundation
import UIKit

class HomeViewModel {
    var awardMovies: [DummyMovie] = []
    var hotMovies: [DummyMovie] = []
    var myMovies: [DummyMovie] = []
    
    init() {
        fetchDummyMovies(.my)
        fetchDummyMovies(.hot)
        fetchDummyMovies(.award)
    }
}

extension HomeViewModel {
    var numberOfSections: Int {
        return Section.allCases.count + 1
    }
}

extension HomeViewModel {
    func fetchDummyMovies(_ type: Section) {
        HomeService.fetchMovies(type) { dummyMovies in
            switch type {
            case .award:
                self.awardMovies = dummyMovies
            case .hot:
                self.hotMovies = dummyMovies
            case .my:
                self.myMovies = dummyMovies
            }
        }
    }
    
    func fetchSectionTitle(_ type: Section) -> String {
        switch type {
        case .award:
            return "아카데미 호평 현황"
        case .hot:
            return "취향저격 HOT 콘텐츠"
        case .my:
            return "내가 찜한 콘텐츠"
        }
    }
    
    func numberOfItemsInSection(_ type: Section) -> Int {
        switch type {
        case .award:
            return awardMovies.count
        case .hot:
            return hotMovies.count
        case .my:
            return myMovies.count
        }
    }
}
