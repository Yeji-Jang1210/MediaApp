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
        case nasa
        
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
            case .nasa:
                return "nasa"
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
            case .nasa:
                return UIImage(systemName: "globe.asia.australia.fill")
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
            case .nasa:
                return NasaViewController()
            }
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupStyle()
        
        let viewControllers = Tab.allCases.map { tab -> UINavigationController in
            let vc = tab.vc
            vc.tabBarItem = UITabBarItem(title: tab.title, image: tab.icon, tag: tab.rawValue)
            
            return UINavigationController(rootViewController: vc)
        }
        
        self.viewControllers = viewControllers
        
        self.selectedIndex = Tab.main.rawValue
    }
    
    private func setupStyle() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundImage = UIImage()
        navBarAppearance.backgroundColor = .black
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        
        UITabBar.appearance().backgroundImage = UIImage.colorForNavBar(color: .black)
        UITabBar.appearance().shadowImage = UIImage.colorForNavBar(color: .black)
        
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .regular)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .regular)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.lightGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        
    }
}

//MARK: - Extension
extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
