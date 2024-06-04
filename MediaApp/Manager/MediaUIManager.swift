//
//  MediaUIManager.swift
//  MediaApp
//
//  Created by 장예지 on 6/4/24.
//

import UIKit
import SnapKit

class SignUpTextField: UITextField {
    
    override var placeholder: String? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.layer.cornerRadius = 4
        self.backgroundColor = .darkGray
        self.textColor = .white
        self.textAlignment = .center
        self.font = .systemFont(ofSize: 12)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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

class CurrentHotContentPoster: UIView {
    
    var image: UIImage? {
        didSet {
            posterImageView.image = image
        }
    }
    
    let backgroundView: UIView = {
        let object = UIView()
        object.clipsToBounds = true
        object.layer.cornerRadius = 4
        object.backgroundColor = .systemGray6
        return object
    }()
    
    let posterImageView: UIImageView = {
       let object = UIImageView()
        object.contentMode = .scaleAspectFill
        return object
    }()
    
    let singleLogoImageView: UIImageView = {
       let object = UIImageView()
        object.image = UIImage(named: "single-badge")
        object.contentMode = .scaleAspectFit
        return object
    }()
    
    let top10BadgeImageView: UIImageView = {
        let object = UIImageView()
        object.image = UIImage(named: "top10 badge")
        object.contentMode = .scaleAspectFit
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy(){
        self.addSubview(backgroundView)
        backgroundView.addSubview(posterImageView)
        backgroundView.addSubview(singleLogoImageView)
        backgroundView.addSubview(top10BadgeImageView)
    }
    
    private func configureLayout(){
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        singleLogoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.size.equalTo(20)
        }
        
        top10BadgeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(20)
        }
    }
}
