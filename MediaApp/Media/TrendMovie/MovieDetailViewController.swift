//
//  MovieDetailViewController.swift
//  MediaApp
//
//  Created by 장예지 on 6/10/24.
//

import UIKit

import Alamofire
import Kingfisher
import SnapKit

enum MovieDetailSection: Int, CaseIterable {
    case overView = 0
    case cast = 1
    
    var header: String {
        switch self {
        case .overView:
            return "OverView"
        case .cast:
            return "Cast"
        }
    }
}

class MovieDetailViewController: BaseVC {
    
    //MARK: - object
    let tableView: UITableView = {
        let object = UITableView(frame: .zero, style: .plain)
        object.backgroundColor = .black
        return object
    }()
    
    //MARK: - properties
    var movie: Movie?
    var isExpanded: Bool = false {
        didSet {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        view.addSubview(tableView)
    }
    
    override func configureLayout(){
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    override func configureUI(){
        configureNavigation()
        configureTableView()
    }
    
    func configureNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func configureTableView(){
        let posterView = CustomMovieDetailView()
        posterView.loadImage(data: movie)
        tableView.tableHeaderView = posterView
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorColor = .white
        tableView.register(CastTableViewCell.self, forCellReuseIdentifier: CastTableViewCell.identifier)
        tableView.register(ExpandTextViewCell.self, forCellReuseIdentifier: ExpandTextViewCell.identifier)
    }
    
    
    //MARK: - function
    @objc func expandOverViewLabel(){
        isExpanded.toggle()
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        } else {
            return 240
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieDetailSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = MovieDetailSection(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        
        switch section {
        case .overView:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpandTextViewCell.identifier) as! ExpandTextViewCell
                                      cell.fetchData(movie?.overview)
            cell.overViewLabel.numberOfLines = isExpanded ? 0 : 2
            cell.button.addTarget(self, action: #selector(expandOverViewLabel), for: .touchUpInside)
            return cell
            
        case .cast:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier, for: indexPath) as! CastTableViewCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
            
            cell.collectionView.reloadData()
            return cell
        }
        
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return movie?.credit?.cast.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as! CastCollectionViewCell
        if let cast = movie?.credit?.cast {
            cell.fetchData(cast[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.height * 0.7
        return CGSize(width: width, height: collectionView.bounds.height)
    }
}
