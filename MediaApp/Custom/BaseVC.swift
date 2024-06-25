//
//  BaseVC.swift
//  MediaApp
//
//  Created by 장예지 on 6/5/24.
//

import UIKit

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().backgroundColor = .black
        
        navigationController?.navigationBar.standardAppearance = appearance
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    //MARK: - configure function
    func configureHierarchy(){
        
    }
    
    func configureLayout(){
        
    }
    
    func configureUI(){
        
    }
}
