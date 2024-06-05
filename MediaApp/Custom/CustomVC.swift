//
//  CustomVC.swift
//  MediaApp
//
//  Created by 장예지 on 6/5/24.
//

import UIKit

class MediaViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        configureNavigation()
    }
    
    func configureNavigation(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().backgroundColor = .black
        
        navigationController?.navigationBar.standardAppearance = appearance
    }
}
