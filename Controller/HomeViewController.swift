//
//  HomeViewController.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/01.
//

import UIKit
import SnapKit


class HomeViewController: UIViewController {
    
    let viewModel = HomeViewModel()
    
    var movies: [UIImage] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(MovieTopCollectionViewCell.self, forCellWithReuseIdentifier: MovieTopCollectionViewCell.identifier)
        collectionView.register(MovieCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieCollectionHeaderView.identifier)
        collectionView.dataSource = self

        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchMovie()
    }
    
    func fetchMovie() {
        for i in 1...18 {
            guard let image = UIImage(named: "img_movie_\(i)") else { return }
            movies.append(image)
        }
    }
    
//    static func fetch(_ type: Section) -> [DummyMovie] {
//        switch type {
//        case .award:
//            let movies = (1..<10).map { DummyMovie(thumbnail: UIImage(named: "img_movie_\($0)")!) }
//            return movies
//        case .hot:
//            let movies = (10..<19).map { DummyMovie(thumbnail: UIImage(named: "img_movie_\($0)")!) }
//            return movies
//        case .my:
//            let movies = (1..<10).map { $0 * 2 }.map { DummyMovie(thumbnail: UIImage(named: "img_movie_\($0)")!) }
//            return movies
//        }
//    }

    func setupUI() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {[weak self] sectionNumber, env -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                return self?.createMainLayout()
            default:
                return self?.createBasicLayout()
            }
        }
    }
    
    func createBasicLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120.0), heightDimension: .absolute(160.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(160.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let titleHeader = createTitleHeaderLayout()
        section.boundarySupplementaryItems = [ titleHeader ]
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    func createMainLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(400.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(400.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        
        return section
    }
    
    func createTitleHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        return header
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return movies.count
        case 2:
            return movies.count
        case 3:
            return movies.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieTopCollectionViewCell.identifier, for: indexPath) as? MovieTopCollectionViewCell,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell() }
        cell.backgroundColor = .systemBackground
        
        switch indexPath.section {
        case 0:
            return mainCell
        case 1:
            cell.movieImage.image = movies[indexPath.row]
            return cell
        case 2:
            cell.movieImage.image = movies[indexPath.row]
            return cell
        case 3:
            cell.movieImage.image = movies[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieCollectionHeaderView.identifier, for: indexPath) as? MovieCollectionHeaderView else { return UICollectionReusableView() }
        if indexPath.section == 1 {
            header.titleLabel.text = Section.award.sectionTitle
        } else if indexPath.section == 2 {
            header.titleLabel.text = Section.hot.sectionTitle
        } else if indexPath.section == 3 {
            header.titleLabel.text = Section.my.sectionTitle
        }
        
        return header
    }
}

