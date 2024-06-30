//
//  CastTableViewCell.swift
//  MediaApp
//
//  Created by 장예지 on 6/10/24.
//

import UIKit

import Kingfisher
import SnapKit


class CastTableViewCell: UITableViewCell, Identifier {
    
    static var identifier: String = String(describing: CastTableViewCell.self)
    
    //MARK: - object
    let collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.backgroundColor = .clear
        return object
    }()
    
    //MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy(){
        contentView.addSubview(collectionView)
    }
    
    func configureLayout(){
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
