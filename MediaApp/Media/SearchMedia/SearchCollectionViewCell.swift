//
//  SearchCollectionViewCell.swift
//  MediaApp
//
//  Created by 장예지 on 6/11/24.
//

import UIKit

import Cosmos
import Kingfisher
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell, Identifier {
    static var identifier = String(describing: SearchCollectionViewCell.self)
    
//MARK: - object
    let backView: UIView = {
        let object = UIView()
        object.backgroundColor = .white
        return object
    }()
    
    let imageView: UIImageView = {
        let object = UIImageView()
        object.clipsToBounds = true
        object.contentMode = .scaleAspectFill
        object.backgroundColor = .black
        return object
    }()
    
    let titleLabel: UILabel = {
        let object = UILabel()
        object.text = "testTitle"
        object.font = .boldSystemFont(ofSize: 14)
        object.textColor = .black
        return object
    }()
    
    let starRatingView: CosmosView = {
        let object = CosmosView()
        object.settings.updateOnTouch = false
        object.settings.totalStars = 5
        object.settings.starSize = 16
        object.settings.starMargin = 5
        object.settings.emptyColor = .systemGray6
        object.settings.emptyBorderColor = .clear
        object.settings.filledBorderColor = .clear
        object.settings.filledColor = .systemYellow
        return object
    }()
    
    let genreLabel: UILabel = {
        let object = UILabel()
        object.text = "#Romance #Romance #Romance"
        object.textColor = .darkGray
        object.font = .systemFont(ofSize: 10)
        return object
    }()
    
    let adultImageView: UIImageView = {
       let object = UIImageView()
        object.image = UIImage(named: "adult")
        object.contentMode = .scaleAspectFit
        return object
    }()

//MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .orange
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy(){
        contentView.addSubview(backView)
        
        backView.addSubview(imageView)
        backView.addSubview(titleLabel)
        backView.addSubview(starRatingView)
        backView.addSubview(genreLabel)
        backView.addSubview(adultImageView)
    }
    
    private func configureLayout(){
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(backView.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(imageView.snp.width).multipliedBy(1.4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(imageView.snp.horizontalEdges)
            make.height.equalTo(16)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(imageView.snp.horizontalEdges)
            make.height.equalTo(14)
        }
        
        starRatingView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(imageView.safeAreaLayoutGuide).inset(8)
        }
        
        adultImageView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).offset(12)
            make.trailing.equalTo(imageView.snp.trailing).inset(12)
            make.size.equalTo(30)
        }
    }
    
    public func fetchData(data: TVProgram){
        if let path = data.poster_path, let url = URL(string: MediaAPI.imageURL(imagePath: path).url) {
            imageView.kf.setImage(with: url)
        }
        
        adultImageView.isHidden = !data.adult
        titleLabel.text = data.original_name
        genreLabel.text = data.genreText
        starRatingView.rating = data.vote_average / 2
    }
}
