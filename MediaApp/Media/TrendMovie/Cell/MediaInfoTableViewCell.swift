//
//  MediaInfoTableViewCell.swift
//  MediaApp
//
//  Created by 장예지 on 6/10/24.
//

import UIKit
import Kingfisher

class MediaInfoTableViewCell: UITableViewCell, Identifier {
    
    static var identifier = String(describing: MediaInfoTableViewCell.self)

    //MARK: - object
    let dateLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 12)
        object.textColor = .systemGray2
        return object
    }()
    
    let categoryLabel: UILabel = {
        let object = UILabel()
        object.font = .boldSystemFont(ofSize: 16)
        object.textColor = .white
        return object
    }()
    
    let mediaInfoView: UIView = {
        let object = UIView()
        object.backgroundColor = .white
        object.clipsToBounds = true
        object.layer.cornerRadius = 12
        return object
    }()
    
    let likedButton: UIButton = {
        let object = UIButton(type: .system)
        object.setBackgroundImage(UIImage(systemName: "paperclip.circle.fill"), for: .normal)
        object.tintColor = .white
        return object
    }()
    
    let stackView: UIStackView = {
        let object = UIStackView()
        object.axis = .horizontal
        object.alignment = .fill
        object.distribution = .fillEqually
        return object
    }()
    
    let gradeTitleLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 10)
        object.backgroundColor = .purple
        object.textColor = .white
        object.textAlignment = .center
        object.text = "평점"
        return object
    }()
    
    let gradeLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 10)
        object.backgroundColor = .white
        object.textColor = .black
        object.textAlignment = .center
        object.text = "3.3"
        return object
    }()
    
    let mediaImageView: UIImageView = {
        let object = UIImageView()
        object.backgroundColor = .systemGray5
        object.contentMode = .scaleAspectFill
        object.clipsToBounds = true
        return object
    }()
    
    let titleLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 14)
        return object
    }()
    
    let casterLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 12)
        return object
    }()
    
    let seperatorLine: UIView = {
        let object = UIView()
        object.backgroundColor = .black
        return object
    }()
    
    let moreInfoLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 10)
        object.text = "자세히 보기"
        return object
    }()
    
    let moreInfoButton: UIButton = {
        let object = UIButton(type: .system)
        object.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        object.tintColor = .darkGray
        return object
    }()
    
    //MARK: - properties
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .black
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure function
    func configureHierarchy(){
        contentView.addSubview(dateLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(mediaInfoView)
        
        mediaInfoView.addSubview(mediaImageView)
        mediaInfoView.addSubview(likedButton)
        mediaInfoView.addSubview(stackView)
        mediaInfoView.addSubview(titleLabel)
        mediaInfoView.addSubview(casterLabel)
        mediaInfoView.addSubview(seperatorLine)
        mediaInfoView.addSubview(moreInfoLabel)
        mediaInfoView.addSubview(moreInfoButton)
        
        stackView.addArrangedSubview(gradeTitleLabel)
        stackView.addArrangedSubview(gradeLabel)
    }
    
    func configureLayout(){
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(16)
            make.leading.equalTo(mediaInfoView.snp.leading)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(mediaInfoView.snp.horizontalEdges)
        }
        
        mediaInfoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
            make.height.equalTo(mediaInfoView.snp.width).multipliedBy(1)
            make.bottom.equalToSuperview().inset(20)
        }
        
        mediaImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.65)
        }
        
        likedButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.size.equalTo(30)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(mediaImageView.snp.leading).offset(12)
            make.bottom.equalTo(mediaImageView.snp.bottom).inset(12)
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(mediaImageView.snp.bottom).offset(12)
        }
        
        casterLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(titleLabel.snp.horizontalEdges)
        }
        
        seperatorLine.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(casterLabel.snp.horizontalEdges)
            make.top.greaterThanOrEqualTo(casterLabel.snp.bottom).offset(-20)
            make.height.equalTo(1)
        }
        
        moreInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(seperatorLine.snp.bottom).offset(20)
            make.leading.equalTo(seperatorLine.snp.leading)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        moreInfoButton.snp.makeConstraints { make in
            make.trailing.equalTo(seperatorLine.snp.trailing)
            make.size.equalTo(20)
            make.centerY.equalTo(moreInfoLabel.snp.centerY)
        }
    }
    
    func configureUI(){
        
    }

//MARK: - function
    public func setData(_ data: Movie){
        dateLabel.text = data.release_date
        categoryLabel.text = data.genreText
        
        if let url = URL(string: MediaAPI.imageURL(imagePath: data.poster_path).url) {
            mediaImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = data.original_title
        casterLabel.text = data.credit?.castText
        gradeLabel.text = String(format: "%.1f", data.vote_average)
    }
}
