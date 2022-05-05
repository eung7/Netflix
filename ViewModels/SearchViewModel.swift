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
    var items: [Item] = []
    
    /// URLSession을 이용한 Network Method
    func fetchMovies(from term: String, completion: @escaping () -> Void) {
        /// 한글, 띄어쓰기 등의 인식을 위해 URLEncoding하는 Code
        let term = term.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed)!
        
        /// 너무 상수 선언이 많은 것 같아서 urlComponents들은 선언을 안해줬음.
        let url = URL(string: "https://itunes.apple.com/search?term=\(term)&media=movie&entity=movie&limit=20")!
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        /// 데이터를 받아오면 실행되는 Method
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            /// 사실 DispatchQueue는 여기서 필요 없지만, 습관성으로 써줌.
            /// 왜 필요 없냐면?
            /// SearchBarDelegate Method뒤에 더 이상 로직이 존재하지 않음.
            DispatchQueue.main.async {
                do {
                    /// URLSession은 JSONDecoder의 인스턴스를 직접 생성하여 Decode해줘야하지만
                    /// Alamofire은 라이브러리에서 자동으로 해준다 !
                    let object = try JSONDecoder().decode(Result.self, from: data!)
                    self.items = object.results
                    
                    /// @escaping Closure를 둔 이유는?
                    ///
                    /// searchBar에서 검색을 끝낸다음
                    /// 들어온 데이터를 movies에 넣고
                    /// SearchVC에서 collectionView.reloadData를 실행시켜주기 위함이다.
                    /// 결국에는 로직이 순차적으로 진행될 수 있기 위함이다.
                    ///
                    /// 따라서 SearchVC에 있는 CollectionView가 Updated movies를 가지고 reloadData()를 실행시킬 수가 있다.
                    completion()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        .resume()
    }
    
    func fetchMoviesWithAF(from term: String, completion: @escaping () -> Void) {
        
        /// URLComponents는 한글, 띄어쓰기 등을 자동으로 인코딩해줌
        var components = URLComponents(string: "https://itunes.apple.com/search")!

        let search = URLQueryItem(name: "term", value: term)
        let media = URLQueryItem(name: "media", value: "movie")
        let entity = URLQueryItem(name: "entity", value: "movie")
        let limit = URLQueryItem(name: "limit", value: "20")

        components.queryItems =  [ search, media, entity, limit ]

        let url = components.url!
        
        print(url)
        
        /// jsonEncoding시에 필요한 Alamofire에서만 정의된 Type인 Parameters
//        let param: Parameters = [
//            "term": term,
//            "media": "movie",
//            "entity": "movie",
//            "limit": "20"
//        ]
        
        AF
            .request(url)
        /// Status Code가 200...300이 나왔을 때 진행될 수 있게 하는 Method
            .validate()
        /// 따로 JsonDecoder 인스턴스를 만들어주지 않아도 자동으로 해준다.
            .responseDecodable(of: Result.self) {[weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let result):
                    self.items = result.results
                    completion()
                case .failure(let error):
                    print("Error! : \(error.localizedDescription)")
                }
            }
            .resume()
    }
}
