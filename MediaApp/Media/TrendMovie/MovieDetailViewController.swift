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
    let backImageView: UIImageView = {
        let object = UIImageView()
        object.backgroundColor = .darkGray
        object.contentMode = .scaleAspectFill
        object.clipsToBounds = true
        return object
    }()
    
    let overlayBackView: UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return object
    }()
    
    let posterImageView: UIImageView = {
        let object = UIImageView()
        object.backgroundColor = .white
        object.contentMode = .scaleAspectFill
        object.clipsToBounds = true
        return object
    }()
    
    let titleLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 24, weight: .heavy)
        object.textColor = .white
        return object
    }()
    
    let tableView: UITableView = {
        let object = UITableView()
        object.backgroundColor = .clear
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
        view.addSubview(backImageView)
        view.addSubview(overlayBackView)
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
    }
    
    override func configureLayout(){
        backImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(backImageView.snp.width).multipliedBy(0.5)
        }
        
        overlayBackView.snp.makeConstraints { make in
            make.edges.equalTo(backImageView)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(backImageView.snp.bottom).inset(12)
            make.width.equalTo(posterImageView.snp.height).multipliedBy(0.7)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(backImageView.snp.top).offset(12)
            make.horizontalEdges.equalTo(backImageView.snp.horizontalEdges).inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(backImageView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
    }
    
    override func configureUI(){
        configureNavigation()
        configureTableView()
        
        fetchData()
    }
    
    func configureNavigation() {
        navigationItem.title = "출연/제작"
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorColor = .white
        tableView.register(CastTableViewCell.self, forCellReuseIdentifier: CastTableViewCell.identifier)
        tableView.register(ExpandTextViewCell.self, forCellReuseIdentifier: ExpandTextViewCell.identifier)
    }
    
    func fetchData(){
        loadImage(backImageView, path: movie?.backdrop_path)
        loadImage(posterImageView, path: movie?.poster_path)
        titleLabel.text = movie?.original_title
    }
    
    func loadImage(_ imageView: UIImageView, path: String?){
        guard let path, let url = URL(string: MediaAPI.imageURL(imagePath: path).url) else { return }
        
        imageView.kf.setImage(with: url)
    }
    
    //MARK: - function
    @objc func expandTextView(){
        //20240611 expand textView 구현하기..
        isExpanded.toggle()
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MovieDetailSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return MovieDetailSection(rawValue: section)?.header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = MovieDetailSection(rawValue: section) else { return 0 }
        
        switch section {
        case .overView:
            return 1
        case .cast:
            guard let count = movie?.credit?.cast.count else { return 0 }
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = MovieDetailSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .overView:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpandTextViewCell.identifier) as! ExpandTextViewCell
            cell.fetchData(movie?.overview)
            cell.overViewLabel.numberOfLines = isExpanded ? 0 : 2
            cell.button.addTarget(self, action: #selector(expandTextView), for: .touchUpInside)
            return cell
            
        case .cast:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier, for: indexPath) as! CastTableViewCell
            if let cast = movie?.credit?.cast[indexPath.row] {
                cell.fetchData(cast)
            }
            return cell
        }
        
    }
}
