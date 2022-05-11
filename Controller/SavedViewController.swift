//
//  SavedViewController.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/01.
//

import UIKit
import Kingfisher
import SnapKit

class SavedViewController: UIViewController {
    
    let starMovieManager = StarMoviesManager.shared
    
    let viewModel = SavedViewModel()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: (UIScreen.main.bounds.width - 64) / 3,
            height: 160.0
        )
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SavedCollectionViewCell.self, forCellWithReuseIdentifier: SavedCollectionViewCell.identifier)
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func setupUI() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SavedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return starMovieManager.starMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedCollectionViewCell.identifier, for: indexPath) as? SavedCollectionViewCell else { return UICollectionViewCell() }
        let imageURL = URL(string: starMovieManager.starMovies[indexPath.row].poster)
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(
            with: imageURL,
            placeholder: .none,
            options: [.transition(.fade(0.3))],
            completionHandler: nil
        )
        
        return cell
    }
}

extension SavedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = starMovieManager.starMovies[indexPath.row]
        
        let vc = PlayerViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.prepareVideo(item: movie)
        
        present(vc, animated: true)
    }
}
