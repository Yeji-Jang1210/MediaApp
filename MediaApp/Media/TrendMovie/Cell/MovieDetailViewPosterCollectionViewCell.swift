//
//  MovieDetailViewPosterCollectionViewCell.swift
//  MediaApp
//
//  Created by 장예지 on 7/1/24.
//

import UIKit

import SnapKit
import Kingfisher

class MovieDetailViewPosterCollectionViewCell: UICollectionViewCell, Identifier {
    static var identifier: String = String(describing: MovieDetailViewPosterCollectionViewCell.self)
    
    let posterImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFill
        object.clipsToBounds = true
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
        contentView.addSubview(posterImageView)
    }
    
    private func configureLayout(){
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func loadPosterImage(path: String?){
        guard let path = path, let url = URL(string: MediaAPI.imageURL(imagePath: path).url) else { return }
        
        print(url)
        
        posterImageView.kf.setImage(with: url)
    }
}
