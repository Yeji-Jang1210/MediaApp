//
//  PosterCollectionViewCell.swift
//  MediaApp
//
//  Created by 장예지 on 6/24/24.
//

import UIKit
import SnapKit
import Kingfisher

class PosterCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: PosterCollectionViewCell.self)
    
    //MARK: - object
    
    let posterImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFill
        object.clipsToBounds = true
        object.layer.cornerRadius = 4
        return object
    }()
    //MARK: - properties
    
    //MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        contentView.addSubview(posterImageView)
    }
    
    private func configureLayout(){
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureUI(){
        contentView.backgroundColor = .clear
    }
    
    //MARK: - function
    public func setImage(path: String){
        guard let url = URL(string: path) else { return }
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(with: url)
    }
}
