//
//  Repository.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/21.
//

import Foundation
import Alamofire

/// 서버에서 원본데이터를 가져온다.
class Repository {
    static func fetchMovies(from term: String, completion: @escaping ([Movie]) -> Void) {
        var components = URLComponents(string: "https://itunes.apple.com/search")!
        let search = URLQueryItem(name: "term", value: term)
        let media = URLQueryItem(name: "media", value: "movie")
        let entity = URLQueryItem(name: "entity", value: "movie")
        let limit = URLQueryItem(name: "limit", value: "20")
        components.queryItems =  [ search, media, entity, limit ]
        let url = components.url!
        
        AF
            .request(url)
            .validate()
            .responseDecodable(of: Result.self) { response in
                switch response.result {
                case .success(let result):
//                    DispatchQueue.main.async {
                        completion(result.results)
//                    }
                case .failure(let error):
                    print("Error! : \(error.localizedDescription)")
                }
            }
            .resume()
    }
}
