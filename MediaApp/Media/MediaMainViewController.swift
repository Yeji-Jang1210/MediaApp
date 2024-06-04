//
//  MediaMainViewController.swift
//  MediaApp
//
//  Created by 장예지 on 6/4/24.
//

import UIKit
import SnapKit

class MediaMainViewController: MediaViewController {
    
    let contentScrollView: UIScrollView = {
        let object = UIScrollView()
        object.backgroundColor = .clear
        object.showsHorizontalScrollIndicator = false
        return object
    }()
    
    let contentView: UIView = {
        let object = UIView()
        object.backgroundColor = .clear
        return object
    }()
    
    let mainPosterOvelayView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFill
        object.clipsToBounds = true
        object.layer.cornerRadius = 12
        object.image = UIImage(named: "background")
        return object
    }()
    
    let mainPosterImageView: UIImageView = {
        let object = UIImageView()
        object.clipsToBounds = true
        object.layer.cornerRadius = 12
        object.contentMode = .scaleAspectFill
        object.image = UIImage(named: "노량")
        return object
    }()
    
    let mainPosterCategory: UILabel = {
        let object = UILabel()
        object.textColor = .white
        object.text = "응원하고픈 · 흥미진진 · 사극 · 전투 · 한국작품"
        object.font = .systemFont(ofSize: 14)
        return object
    }()
    
    let playButton: UIButton = {
        let object = UIButton(type: .system)
        object.layer.cornerRadius = 4
        object.tintColor = .black
        object.backgroundColor = .white
        object.setImage(UIImage(named: "play"), for: .normal)
        object.setTitle("재생", for: .normal)
        object.titleLabel?.font = .systemFont(ofSize: 12)
        return object
    }()
    
    let wishListButton: UIButton = {
        let object = UIButton(type: .system)
        object.layer.cornerRadius = 4
        object.backgroundColor = .darkGray
        object.setImage(UIImage(systemName: "plus"), for: .normal)
        object.setTitle("내가 찜한 리스트",for: .normal)
        object.titleLabel?.font = .systemFont(ofSize: 12)
        object.tintColor = .white
        return object
    }()
    
    let buttonStackView: UIStackView = {
        let object = UIStackView()
        object.axis = .horizontal
        object.distribution = .fillEqually
        object.spacing = 12
        return object
    }()
    
    let currentHotContentsImageStackView: UIStackView = {
        let object = UIStackView()
        object.axis = .horizontal
        object.distribution = .fillEqually
        object.spacing = 12
        return object
    }()
    
    let currentHodContentsLabel: UILabel = {
        let object = UILabel()
        object.textColor = .white
        object.text = "지금 뜨는 콘텐츠"
        object.font = .systemFont(ofSize: 14)
        return object
    }()
    
    lazy var hotContentImageList = [firstCurrentHotImageView, secontCurrentHotImageView, thridCurrentHotImageView]
    
    let firstCurrentHotImageView: CurrentHotContentPoster = {
        let object = CurrentHotContentPoster()
        object.image = UIImage(named: "육사오")
        return object
    }()
    
    let secontCurrentHotImageView: CurrentHotContentPoster = {
        let object = CurrentHotContentPoster()
        object.image = UIImage(named: "오펜하이머")
        return object
    }()
    
    let thridCurrentHotImageView: CurrentHotContentPoster = {
        let object = CurrentHotContentPoster()
        object.image = UIImage(named: "서울의봄")
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
    }
    
    func configureNavigationBar(){
        navigationItem.title = "고래밥님"
    }
    
    func configureHierarchy(){
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentView)
        contentView.addSubview(mainPosterImageView)
        contentView.addSubview(mainPosterOvelayView)
        contentView.addSubview(mainPosterCategory)
        contentView.addSubview(currentHodContentsLabel)
        contentView.addSubview(currentHotContentsImageStackView)
        
        contentView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(playButton)
        buttonStackView.addArrangedSubview(wishListButton)
        
        for (index, item) in hotContentImageList.enumerated() {
            currentHotContentsImageStackView.addArrangedSubview(item)
            item.tag = index
        }
    }
    
    func configureLayout(){
        contentScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(contentScrollView.contentLayoutGuide)
            make.width.equalTo(contentScrollView.frameLayoutGuide)
        }
        
        mainPosterImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(24)
            make.height.equalTo(mainPosterImageView.snp.width).multipliedBy(1.4)
        }
        
        mainPosterOvelayView.snp.makeConstraints { make in
            make.edges.equalTo(mainPosterImageView)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(mainPosterImageView).inset(12)
        }
        
        playButton.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        wishListButton.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        mainPosterCategory.snp.makeConstraints { make in
            make.bottom.equalTo(buttonStackView.snp.top).offset(-12)
            make.centerX.equalTo(mainPosterImageView.snp.centerX)
        }
        
        currentHodContentsLabel.snp.makeConstraints { make in
            make.top.equalTo(mainPosterImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
        }
        
        currentHotContentsImageStackView.snp.makeConstraints { make in
            make.top.equalTo(currentHodContentsLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        for item in hotContentImageList {
            item.snp.makeConstraints { make in
                make.height.equalTo(item.snp.width).multipliedBy(1.4)
            }
        }
    }
}

class CurrentHotContentsImageView: UIImageView {
    
    override init(image: UIImage? = nil) {
        super.init(image: image)
        self.clipsToBounds = true
        self.layer.cornerRadius = 4
        self.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
