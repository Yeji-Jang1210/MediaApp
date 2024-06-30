//
//  CustomMovieDetailView.swift
//  MediaApp
//
//  Created by 장예지 on 6/28/24.
//

import UIKit
import Cosmos
import SnapKit
import Kingfisher

class MovieInfoView: UIView {
    
    let titleLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 24, weight: .bold)
        object.textColor = .white
        object.numberOfLines = 2
        return object
    }()
    
    let starRatingView: CosmosView = {
        let object = CosmosView()
        object.settings.updateOnTouch = false
        object.settings.totalStars = 5
        object.settings.starSize = 24
        object.settings.starMargin = 5
        object.settings.emptyColor = .systemGray6
        object.settings.emptyBorderColor = .clear
        object.settings.filledBorderColor = .clear
        object.settings.filledColor = .systemYellow
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    @available(* , unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy(){
        addSubview(starRatingView)
        addSubview(titleLabel)
    }
    
    func configureLayout(){
        starRatingView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-12)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func configureUI(){
        
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let sublayers = layer.sublayers {
            for sublayer in sublayers {
                if sublayer is CAGradientLayer {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.2).cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.6, 0.9]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
