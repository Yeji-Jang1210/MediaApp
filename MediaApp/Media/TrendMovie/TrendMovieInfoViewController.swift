//
//  TrendMovieInfoViewController.swift
//  MediaApp
//
//  Created by 장예지 on 6/10/24.
//

import UIKit
import Alamofire

class TrendMovieInfoViewController: BaseVC {
    //MARK: - object
    let tableView: UITableView = {
        let object = UITableView()
        return object
    }()
    
    let scrollTopButton: UIButton = {
        let object = UIButton(type: .system)
        object.setBackgroundImage(UIImage(systemName: "chevron.up.circle.fill"), for: .normal)
        object.tintColor = .red
        return object
    }()
    
    let textField: UITextField = {
        let object = UITextField()
        object.textColor = .white
        object.attributedPlaceholder = NSAttributedString(string: "영화 이름을 검색하세요.", attributes: [.foregroundColor : UIColor.systemGray2.cgColor])
        return object
    }()
    
    //MARK: - properties
    var list: [Movie] = []
    var filterList: [Movie] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        GenreManager.fetchData(for: MediaAPI.movieGenreURL)
        
        callTrendingMovieAPIResponse { movies in
            guard let movies else { return }
            self.list = movies
            self.filterList = self.list
        }
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        view.addSubview(tableView)
        view.addSubview(scrollTopButton)
        navigationItem.titleView = textField
    }
    
    override func configureLayout(){
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollTopButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(40)
        }
    }
    
    override func configureUI(){
        configureTableView()
        configureNavigation()
        scrollTopButton.addTarget(self, action: #selector(scrollTopButtonTapped), for: .touchUpInside)
    }
    
    func configureNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(searchButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(menuButtonClicked))
        navigationController?.navigationBar.tintColor = .white
    }
    
    func configureTableView(){
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MediaInfoTableViewCell.self, forCellReuseIdentifier: MediaInfoTableViewCell.identifier)
        tableView.keyboardDismissMode = .onDrag
    }
    
    //MARK: - function
    @objc func scrollTopButtonTapped(){
        tableView.setContentOffset(.zero, animated: true)
    }
    
    @objc func menuButtonClicked(){
        if let text = textField.text {
            guard !text.isEmpty else { return }
            filterList = list.filter{ $0.original_title.lowercased().contains(text.lowercased()) }
            view.endEditing(true)
            tableView.reloadData()
        }
    }
    
    @objc func searchButtonClicked(){
        
    }
    
    func callTrendingMovieAPIResponse(completion: @escaping ([Movie]?) -> Void){
        
        APIManager.callAPI(api: MediaAPI.trendURL, type: TrendMovie.self) { result in
            switch result {
            case .success(let data):
                var movies = data.results
                let dispatchGroup = DispatchGroup()
                
                for index in movies.indices {
                    dispatchGroup.enter()
                    
                    APIManager.callAPI(api: MediaAPI.creditURL(movieId: movies[index].id), type: Credit.self) { result in
                        switch result {
                        case .success(let credit):
                            movies[index].credit = credit
                            dispatchGroup.leave()
                        case .error(let error):
                            print(error)
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(movies)
                }
            case .error(let error):
                print(error)
            }
        }
    }
}

extension TrendMovieInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaInfoTableViewCell.identifier, for: indexPath) as! MediaInfoTableViewCell

        cell.setData(self.filterList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        vc.movie = filterList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
