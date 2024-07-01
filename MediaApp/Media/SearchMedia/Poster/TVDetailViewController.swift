//
//  TVDetailViewController.swift
//  MediaApp
//
//  Created by 장예지 on 6/24/24.
//

import UIKit
import WebKit
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
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let programTitleLabel: UILabel = {
        let object = UILabel()
        object.font = .systemFont(ofSize: 30, weight: .heavy)
        object.textColor = .white
        return object
    }()
    
    let webView: WKWebView = {
        let object = WKWebView()
        return object
    }()
    
    //MARK: - properties
    var programTitle: String = ""
    var id: Int = 0
    var programs: [[TVProgram]] = Array(repeating: [], count: 2)
    var posters: [String] = []
    
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
    
    private func fetchData(){
        
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async {
            self.callAPIForVideoKey(id: self.id) { key in
                guard let key = key else { return }
                guard let url = URL(string: MediaAPI.youtubeURL(key: key).url) else { return }
                
                DispatchQueue.main.async {
                    self.webView.load(URLRequest(url: url))
                }
                group.leave()
            }
        }
        
        for (index, item) in CollectionViewList.allCases.enumerated() {
            group.enter()
            switch item {
            case .similar, .recomments:
                DispatchQueue.global().async {
                    APIManager.callAPI(api: item.getAPIType(id: self.id), type: SearchResult.self) { result in
                        switch result {
                        case .success(let data):
                            self.programs[index] = data.results
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
                                self.posters = data.backdrops.map { MediaAPI.imageURL(imagePath: $0.file_path).url }
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
    
    private func callAPIForVideoKey(id: Int, completion: @escaping (String?) -> Void){
        APIManager.callAPI(api: .getVideoKeyURL(id: id), type: Videos.self) { networkResult in
            switch networkResult {
            case .success(let data):
                completion(data.results.first?.key)
            case .error(let error):
                print(error)
            }
        }
    }
}

extension TVDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return webView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return UIScreen.main.bounds.height * 0.34
        default:
            return UIScreen.main.bounds.height * 0.24
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CollectionViewList.allCases.count
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
        switch collectionView.tag {
        case 0, 1:
            return programs[collectionView.tag].count
        default:
            return posters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
        
        switch collectionView.tag {
        case 0, 1:
            if let path = programs[collectionView.tag][indexPath.row].poster_path {
                cell.setImage(path: MediaAPI.imageURL(imagePath: path).url)
            }
        default:
            cell.setImage(path: posters[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.height * 0.7
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag != 2 {
            callAPIForVideoKey(id: programs[collectionView.tag][indexPath.row].id) { key in
                print("callAPIForVideoKey:\(self.programs[collectionView.tag][indexPath.row].id)")
                if let key = key {
                    let vc = YoutubeWebViewController(url: key)
                    self.present(vc, animated: true)
                }
            }
        }
    }
}
