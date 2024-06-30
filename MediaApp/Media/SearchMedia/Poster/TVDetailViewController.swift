//
//  TVDetailViewController.swift
//  MediaApp
//
//  Created by 장예지 on 6/24/24.
//

import UIKit
import SnapKit

class TVDetailViewController: BaseVC {
    
    enum CollectionViewList: Int, CaseIterable {
        case similar
        case recomments
        case poster
        
        var title: String {
            switch self {
            case .similar:
                return "비슷한 TV 프로그램"
            case .recomments:
                return "추천 TV 프로그램"
            case .poster:
                return "포스터"
            }
        }
        
        var type: Any {
            switch self {
            case .similar, .recomments:
                return SearchResult.self
            case .poster:
                return MediaPosters.self
            }
        }
        
        func getAPIType(id: Int) -> MediaAPI {
            switch self {
            case .similar:
                return MediaAPI.similarURL(id: id)
            case .recomments:
                return MediaAPI.recommendationsURL(id: id)
            case .poster:
                return MediaAPI.getPostersURL(type: .tv, id: id)
            }
        }
    }
    
    //MARK: - object
    let tableView = UITableView()
    
    let programTitleLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 30, weight: .heavy)
        object.textColor = .white
        return object
    }()
    
    //MARK: - properties
    var programTitle: String = ""
    var id: Int = 0
    var paths: [[String]] = Array(repeating: [], count: CollectionViewList.allCases.count)
    
    //MARK: - life cycle
    init(id: Int, title: String){
        super.init(nibName: nil, bundle: nil)
        self.id = id
        self.programTitle = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        
        fetchData()
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        view.addSubview(programTitleLabel)
        view.addSubview(tableView)
    }
    
    override func configureLayout(){
        programTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(programTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI(){
        configureNavigation()
        configureTableView()
        
        view.backgroundColor = .black
        programTitleLabel.text = programTitle
    }
    
    private func configureNavigation(){
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(dismissButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .done, target: self, action: #selector(menuButtonTapped))
    }
    
    private func configureTableView(){
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.identifier)
    }
    
    //MARK: - function
    @objc
    func dismissButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func menuButtonTapped(){
    }
    
    func fetchData(){
        
        let group = DispatchGroup()
    
        for (index, item) in CollectionViewList.allCases.enumerated() {
            group.enter()
            switch item {
            case .similar, .recomments:
                DispatchQueue.global().async {
                    APIManager.callAPI(api: item.getAPIType(id: self.id), type: SearchResult.self) { result in
                        switch result {
                        case .success(let data):
                            self.paths[index] = data.results.filter{$0.poster_path != nil}.map{ MediaAPI.imageURL(imagePath: $0.poster_path!).url }
                                group.leave()
                        case .error(let error):
                            print(error)
                        }
                    }
                }
            case .poster:
                DispatchQueue.global().async {
                    APIManager.callAPI(api: item.getAPIType(id: self.id), type: MediaPosters.self) { result in
                        switch result {
                        case .success(let data):
                                self.paths[index] = data.backdrops.map { MediaAPI.imageURL(imagePath: $0.file_path).url }
                                group.leave()
                        case .error(let error):
                            print(error)
                        }
                    }
                }
            }
        }
        
        group.notify(queue: .main){
            self.tableView.reloadData()
        }
    }
}

extension TVDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return UIScreen.main.bounds.height * 0.34
        default:
            return UIScreen.main.bounds.height * 0.24
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PosterTableViewCell.identifier, for: indexPath) as! PosterTableViewCell
        
        cell.titleLabel.text = CollectionViewList.allCases[indexPath.row].title
        cell.collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        cell.collectionView.tag = indexPath.row
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        
        cell.collectionView.reloadData()
        return cell
    }
}

extension TVDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paths[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
        
        cell.setImage(path: paths[collectionView.tag][indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.height * 0.7
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
