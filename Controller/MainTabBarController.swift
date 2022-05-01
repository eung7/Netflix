//
//  ViewController.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/01.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let homeVC = HomeViewController()
    let searchVC = SearchViewController()
    let upcomingVideoVC = UpcomingVideoViewController()
    let savedVC = SavedViewController()
    let settingVC = SettingViewController()
    
    private lazy var homeTab: UITabBarItem = {
        let tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        return tabBarItem
    }()
    
    private lazy var searchTab: UITabBarItem = {
        let tabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        return tabBarItem
    }()

    private lazy var upcomingVideoTab: UITabBarItem = {
        let tabBarItem = UITabBarItem(
            title: "공개예정",
            image: UIImage(systemName: "play.rectangle"),
            selectedImage: UIImage(systemName: "play.rectangle.fill")
        )
        
        return tabBarItem
    }()

    private lazy var savedTab: UITabBarItem = {
        let tabBarItem = UITabBarItem(
            title: "저장된 콘텐츠 목록",
            image: UIImage(systemName: "square.and.arrow.down"),
            selectedImage: UIImage(systemName: "square.and.arrow.down.fill")
        )
        
        return tabBarItem
    }()

    private lazy var settingTab: UITabBarItem = {
        let tabBarItem = UITabBarItem(
            title: "설정",
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gear")
        )
        
        return tabBarItem
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    func setupTabBar() {
        tabBar.tintColor = .systemPink
        
        viewControllers = [ homeVC, searchVC, upcomingVideoVC, savedVC, settingVC ]
        
        homeVC.tabBarItem = homeTab
        searchVC.tabBarItem = searchTab
        upcomingVideoVC.tabBarItem = upcomingVideoTab
        savedVC.tabBarItem = savedTab
        settingVC.tabBarItem = settingTab
    }
}

