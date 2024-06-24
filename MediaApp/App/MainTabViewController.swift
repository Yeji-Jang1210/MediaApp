//
//  MainTabViewController.swift
//  MediaApp
//
//  Created by 장예지 on 6/24/24.
//

import UIKit

class MainTabViewController: UITabBarController {
    enum Tab: Int, CaseIterable {
        case search
        case hot
        case main
        case signup
        
        var title: String {
            switch self {
            case .search:
                return "search"
            case .hot:
                return "hot"
            case .main:
                return "main"
            case .signup:
                return "signup"
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .search:
                return UIImage(systemName: "magnifyingglass")
            case .hot:
                return UIImage(systemName: "star.fill")
            case .main:
                return UIImage(systemName: "popcorn")
            case .signup:
                return UIImage(systemName: "person")
            }
        }
        
        var vc: UIViewController {
            switch self {
            case .search:
                return MediaSearchViewController()
            case .hot:
                return TrendMovieInfoViewController()
            case .main:
                return MediaMainViewController()
            case .signup:
                return SignUpViewController()
            }
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tabBar.tintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.lightGray
        
        let viewControllers = Tab.allCases.map { tab -> UINavigationController in
            let vc = tab.vc
            vc.tabBarItem = UITabBarItem(title: tab.title, image: tab.icon, tag: tab.rawValue)
            
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black
            
            
            vc.tabBarController?.tabBar.backgroundColor = .black
            vc.tabBarController?.tabBar.barTintColor = .black
            
            vc.tabBarController?.tabBar.scrollEdgeAppearance = appearance
            vc.tabBarController?.tabBar.standardAppearance = appearance 
            
            return UINavigationController(rootViewController: vc)
        }
        
        self.viewControllers = viewControllers
        
        self.selectedIndex = Tab.main.rawValue
    }
}
