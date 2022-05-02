//
//  HomeViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/02.
//

import Foundation

enum Section: String, CaseIterable {
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
        }
    }
}

class HomeViewModel {
    
    
    
}
