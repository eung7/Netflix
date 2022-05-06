//
//  HomeViewController.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/01.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    /// ViewModel Instance
    let viewModel = HomeViewModel()
    
    /// CollectionView 속성 값과 초기화
    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(MovieMainCollectionViewCell.self, forCellWithReuseIdentifier: MovieMainCollectionViewCell.identifier)
        collectionView.register(MovieCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieCollectionHeaderView.identifier)
        collectionView.dataSource = self

        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    /// Auto Layout Method
    func setupUI() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    /// CollectionView 전체 Layout 생성
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {[unowned self] sectionNumber, env -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                return self.createMainLayout()
            default:
                return self.createBasicLayout()
            }
        }
    }
    
    /// CollectionView 섹션 1, 2, 3 Layout 생성
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
    
    /// CollectionView 섹션 0 Layout 생성
    func createMainLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(400.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(400.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        
        return section
    }
    
    /// CollectionView Header Layout 생성
    func createTitleHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        return header
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    /// 몇 개의 Section?
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    /// Section마다 몇개의 Cell이 있는지?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.awardMovies.count
        case 2:
            return viewModel.hotMovies.count
        case 3:
            return viewModel.myMovies.count
        default:
            return 0
        }
    }
    
    /// Cell을 어떻게 표현할 건지?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieMainCollectionViewCell.identifier, for: indexPath) as? MovieMainCollectionViewCell,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell() }
        cell.backgroundColor = .systemBackground
        
        switch indexPath.section {
        case 0:
            return mainCell
        case 1:
            let movies = viewModel.awardMovies
            cell.movieImage.image = movies[indexPath.row].thumbnail
            return cell
        case 2:
            let movies = viewModel.hotMovies
            cell.movieImage.image = movies[indexPath.row].thumbnail
            return cell
        case 3:
            let movies = viewModel.myMovies
            cell.movieImage.image = movies[indexPath.row].thumbnail
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    /// Header를 어떻게 표현할건지?
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

