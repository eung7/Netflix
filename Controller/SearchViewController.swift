//
//  SearchViewController.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/01.
//

import UIKit
import AVKit
import SnapKit
import Kingfisher

class SearchViewController: UIViewController {
    
    /// ViewModel Instance
    let viewModel = SearchViewModel()
    
    /// SearchBar 속성 정의
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        /// deleate를 받기위해 lazy 속성을 부여했다. 만약 부여하지 않으면 Class 초기화 전에 상수가 초기화 되지 않음..
        searchBar.delegate = self
        
        return searchBar
    }()
    
    /// tapGesture 속성 정의
    lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        tapGesture.cancelsTouchesInView = false
        
        return tapGesture
    }()
    
    /// CollectionView 속성 정의
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: (UIScreen.main.bounds.width - 64) / 3,
            height: 160.0
        )
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    /// AutoLayout Method by SnapKit
    func setupUI() {
        view.addGestureRecognizer(tapGesture)
        
        [ searchBar, collectionView ]
            .forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}

/// @objc Method는 모두 여기로
private extension SearchViewController {
    
    /// 빈 화면 터치시 모든 작업 종료
    @objc func didTapBackground() {
        view.endEditing(true)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    /// Cell의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    /// Cell의 표현 by KingFisher
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        let url = URL(string: viewModel.items[indexPath.row].poster)
        
        /// KingFisher를 이용하여 URL을 통해 이미지를 가져온다.
        /// 이미지를 가져올 때 나타내는 애니메이션도 구현 <- KingFisher의 기능
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.3))], completionHandler: nil)
        
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    /// 특정 Cell이 클릭되었을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 특정셀이 클릭되었을 때 PlayerVC에서 동영상이 재생되도록 구현해야함
        let trailerURL = viewModel.items[indexPath.row].trailer
        let videoTitle = viewModel.items[indexPath.row].movieName
        
        let vc = PlayerViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.prepareVideo(url: trailerURL)
        vc.videoTitleLabel.text = videoTitle
        
        present(vc, animated: true, completion: {
            vc.player?.play()
        })
    }
}

/// SearchBar 관련 Method
extension SearchViewController: UISearchBarDelegate {
    
    /// SearchButton(Return)이 클릭되었을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            viewModel.fetchMovies(from: text) {[weak self] in
                self?.collectionView.reloadData()
            }
            view.endEditing(true)
        }
    }
    
    /// SearchBar의 Text가 변경될 때마다 실행되는 Method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            viewModel.fetchMovies(from: text) {[weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
}

