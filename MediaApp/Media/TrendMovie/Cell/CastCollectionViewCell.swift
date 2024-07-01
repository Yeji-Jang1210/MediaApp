//
//  CastCollectionViewCell.swift
//  MediaApp
//
//  Created by 장예지 on 6/29/24.
//

import UIKit

import Kingfisher
import SnapKit

class CastCollectionViewCell: UICollectionViewCell, Identifier {
    
    static var identifier: String = String(describing: CastCollectionViewCell.self)
    
    let backView: UIView = {
        let object = UIView()
        return object
    }()
    
    let actorImageView: UIImageView = {
        let object = UIImageView()
        object.clipsToBounds = true
        object.layer.cornerRadius = 8
        object.contentMode = .scaleAspectFill
        return object
    }()
    
    let actorNameLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 14)
        object.textColor = .white
        return object
    }()
    
    let characterNameLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 12)
        object.textColor = .systemGray2
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
    
    //MARK: - configure function
    private func configureHierarchy(){
        contentView.addSubview(backView)
        backView.addSubview(actorImageView)
        backView.addSubview(actorNameLabel)
        backView.addSubview(characterNameLabel)
    }
    
    private func configureLayout(){
        
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        actorImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        actorNameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(actorImageView.snp.horizontalEdges)
            make.top.equalTo(actorImageView.snp.bottom).offset(4)
        }
        
        characterNameLabel.snp.makeConstraints { make in
            make.top.equalTo(actorNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(actorImageView.snp.horizontalEdges)
            make.bottom.equalToSuperview()
        }
    }
    
    public func fetchData(_ cast: Cast){
        if let path = cast.profile_path, let url = URL(string: MediaAPI.imageURL(imagePath: path).url) {
            actorImageView.kf.setImage(with: url)
        }
        
        actorNameLabel.text = cast.name
        characterNameLabel.text = cast.character
    }
}
