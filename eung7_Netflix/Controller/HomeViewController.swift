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
        StarMovieManager.shared.loadStarMovies()
    }
    
    /// Auto Layout Method
    func setupUI() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    /// CollectionView 전체 Compositional Layout 생성
    func createLayout() -> UICollectionViewCompositionalLayout {
        /// return 값인 UICollectionViewCompositionalLayout은 콜백 함수로 두 개의 인자가 나온다.
        ///
        /// 콜백 함수 :
        /// sectionNumber [int] : sectionNumber마다 다르게 줄 수 있도록하는 인자
        /// env [NSCollectionLayoutEnvironment] : 사이즈, 인셋 등을 줄 수 있는 인자
        /// return [NSCollectionLayoutSection] : 만들어두었던 NSCollectionLayoutSection 객체를 넣어주면 최종적으로 Layout으로 반환됨
        return UICollectionViewCompositionalLayout {[weak self] sectionNumber, _ -> NSCollectionLayoutSection? in
            /// section 번호마다 다른 Layout을 설정하기 위해 switch 문
            switch sectionNumber {
            case 0:
                return self?.createMainLayout()
            default:
                return self?.createBasicLayout()
            }
        }
    }
    
    /// CollectionViewCompositionalLayout 섹션 1, 2, 3 Layout 생성
    /// item ⟶ group ⟶ section 순으로 정의
    func createBasicLayout() -> NSCollectionLayoutSection {
        /// 각 item의 사이즈 설정 ( width: 120, height: 160 )
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120.0), heightDimension: .absolute(160.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        /// 아이템의 마진 값 설정
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        /// 아이템들이 들어갈 Group 설정
        /// groupSize 설정
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(160.0))
        /// subitem에 item을 넣어주고 각 그룹 당 아이템이 보여질 갯수는 3개
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        /// 최종적으로 section 설정
        let section = NSCollectionLayoutSection(group: group)
        
        /// 헤더 생성
        let titleHeader = createTitleHeaderLayout()
        /// 이 Layout은 헤더를 보여지도록 적용
        section.boundarySupplementaryItems = [ titleHeader ]
        /// 어떤 형식의 스크롤을 쓸지 결정
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    /// Main Section CollectionViewLayout 생성
    func createMainLayout() -> NSCollectionLayoutSection {
        /// itemSize 정의 ( width: 스크린의 가로 폭과 동일, height: 400 )
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(400.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        /// 셀이 하나라서 Group 사이즈가 동일
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieMainCollectionViewCell.identifier, for: indexPath) as? MovieMainCollectionViewCell,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell() }
        cell.backgroundColor = .systemBackground
        
        switch indexPath.section {
        case 0:
            mainCell.didTapInterstellarButton = {
                ServiceAPI.fetchMovies(from: "interstellar") { [weak self] items in
                    let vc = PlayerViewController()
                    vc.modalPresentationStyle = .fullScreen
                    
                    if let item = StarMovieManager.shared.starMovies.first(where: { $0.trailer == items[0].trailer }) {
                        vc.prepareVideo(item: item)
                    } else {
                        vc.prepareVideo(item: items[0])
                    }
                    
                    self?.present(vc, animated: true, completion: {
                        vc.player?.play()
                    })
                }
            }
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

