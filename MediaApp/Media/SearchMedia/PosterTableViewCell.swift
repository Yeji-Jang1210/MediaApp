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
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    //MARK: - function
}

extension PosterTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
        
        cell.setImage(path: paths[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.height * 0.7
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
