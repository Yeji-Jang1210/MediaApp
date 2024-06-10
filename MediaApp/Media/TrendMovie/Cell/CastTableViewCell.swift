//
//  CastTableViewCell.swift
//  MediaApp
//
//  Created by 장예지 on 6/10/24.
//

import UIKit

import Kingfisher
import SnapKit


class CastTableViewCell: UITableViewCell {
    
    static var identifier: String = String(describing: CastTableViewCell.self)
    
    //MARK: - object
    
    let actorImageView: UIImageView = {
        let object = UIImageView()
        object.clipsToBounds = true
        object.layer.cornerRadius = 8
        object.contentMode = .scaleAspectFill
        return object
    }()
    
    let stackView: UIStackView = {
        let object = UIStackView()
        object.axis = .vertical
        object.distribution = .fill
        object.alignment = .fill
        object.spacing = 4
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
    
    //MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure function
    func configureHierarchy(){
        contentView.addSubview(actorImageView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(actorNameLabel)
        stackView.addArrangedSubview(characterNameLabel)
    }
    
    func configureLayout(){
        //20240611 autolayout 고치기..
        
        actorImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.width.equalTo(50)
            make.height.equalTo(actorImageView.snp.width).multipliedBy(1.2)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(actorImageView.snp.centerY)
            make.leading.equalTo(actorImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        actorNameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        characterNameLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
    }
    
    func configureUI(){
        
    }
    //MARK: - function
    
    func fetchData(_ data: Cast){
        if let path = data.profile_path, let url = URL(string: MediaAPI.imageURL(imagePath: path).url) {
            actorImageView.kf.setImage(with: url)
        }
        
        actorNameLabel.text = data.name
        characterNameLabel.text = data.character
    }
}
