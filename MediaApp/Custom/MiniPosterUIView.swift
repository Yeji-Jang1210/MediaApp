//
//  MiniPosterUIView.swift
//  MediaApp
//
//  Created by 장예지 on 6/5/24.
//

import UIKit

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
