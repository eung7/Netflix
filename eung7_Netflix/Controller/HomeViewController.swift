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
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {[weak self] sectionNumber, _ -> NSCollectionLayoutSection? in
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
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.numberOfItemsInSection(.award)
        case 2:
            return viewModel.numberOfItemsInSection(.hot)
        case 3:
            return viewModel.numberOfItemsInSection(.my)
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieMainCollectionViewCell.identifier, for: indexPath) as? MovieMainCollectionViewCell,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell() }
        cell.backgroundColor = .systemBackground
        
        switch indexPath.section {
        case 0:
            mainCell.didTapInterstellarButton = {
                Service.fetchStarMovies("interstellar") { [weak self] movies in
                    let vc = PlayerViewController(); vc.modalPresentationStyle = .fullScreen
                    vc.prepareVideo(StarMovieManager.shared.verifyInStarMovies(movies[0]))
                    self?.present(vc, animated: true, completion: {
                        vc.player?.play()
                    })
                }
            }
            return mainCell
        case 1:
            let image = viewModel.awardMovies[indexPath.row].thumbnail
            cell.movieImage.image = image
            return cell
        case 2:
            let image = viewModel.hotMovies[indexPath.row].thumbnail
            cell.movieImage.image = image
            return cell
        case 3:
            let image = viewModel.myMovies[indexPath.row].thumbnail
            cell.movieImage.image = image
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieCollectionHeaderView.identifier, for: indexPath) as? MovieCollectionHeaderView else { return UICollectionReusableView() }
        
        if indexPath.section == 1 {
            header.titleLabel.text = viewModel.fetchSectionTitle(.award)
        } else if indexPath.section == 2 {
            header.titleLabel.text = viewModel.fetchSectionTitle(.hot)
        } else if indexPath.section == 3 {
            header.titleLabel.text = viewModel.fetchSectionTitle(.my)
        }
        return header
    }
}
