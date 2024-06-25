//
//  PosterTableViewCell.swift
//  MediaApp
//
//  Created by 장예지 on 6/24/24.
//

import UIKit

class PosterTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: PosterTableViewCell.self)

    //MARK: - object
    let titleLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 20, weight: .bold)
        object.textColor = .white
        return object
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumLineSpacing = 10
        
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.backgroundColor = .clear
        return object
    }()
    
    //MARK: - properties
    var paths: [String] = []
    
    //MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
    }
    
    private func configureLayout(){
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
    }
    
    private func configureUI(){
        backgroundColor = .clear
    }
    //MARK: - function
}
