//
//  SearchViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/04.
//

import Foundation
import Alamofire

class SearchViewModel {
    
    /// SearchVC에서 하나의 인스턴스만을 참조하고 있으므로 전역변수처럼 쓸 수 있다.
    var movies: [Item] = []
    
    /// URLSession을 이용한 Network Method
    func fetchMovies(from term: String, completion: @escaping () -> Void) {
        let url = URL(string: "https://itunes.apple.com/search?term=\(term)&media=movie&entity=movie&limit=20")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let object = try JSONDecoder().decode(Result.self, from: data!)
                    self.movies = object.results
                    
                    /// @escaping Closure를 둔 이유는?
                    /// ->
                    /// searchBar에서 검색을 끝낸다음
                    /// 들어온 데이터를 movies에 넣고
                    /// SearchVC에서 collectionView.reloadData를 실행시켜주기 위함이다.
                    /// 결국에는 로직이 순차적으로 진행될 수 있기 위함이다.
                    completion()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        .resume()
    }
    
    
}
