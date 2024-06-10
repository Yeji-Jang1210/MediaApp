//
//  TrendMovieInfoViewController.swift
//  MediaApp
//
//  Created by 장예지 on 6/10/24.
//

import UIKit
import Alamofire

class TrendMovieInfoViewController: MediaViewController {
    //MARK: - object
    let tableView: UITableView = {
        let object = UITableView()
        return object
    }()
    
    //MARK: - properties
    var list: [Movie] = []
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        
        GenreManager.fetchData()
        
        callTrendingMovieAPIResponse { movies in
            guard let movies else { return }
            self.list = movies
            self.tableView.reloadData()
        }
    }
    
    //MARK: - configure function
    func configureHierarchy(){
        view.addSubview(tableView)
    }
    
    func configureLayout(){
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI(){
        tabBarController?.tabBarItem = UITabBarItem(title: "Hot", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        configureTableView()
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(menuButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(searchButtonClicked))
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    func configureTableView(){
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MediaInfoTableViewCell.self, forCellReuseIdentifier: MediaInfoTableViewCell.identifier)
    }
    
    //MARK: - function
    @objc func menuButtonClicked(){
        
    }
    
    @objc func searchButtonClicked(){
        
    }
    
    func callTrendingMovieAPIResponse(completion: @escaping ([Movie]?) -> Void){
        AF.request(MediaAPI.trendURL.url, method: .get, headers: APIService.headers).responseDecodable(of: TrendMovie.self){ response in
            switch response.result {
            case .success(let value):
                var movies = value.results
                let dispatchGroup = DispatchGroup()
                
                for index in movies.indices {
                    dispatchGroup.enter()
                    
                    AF.request(MediaAPI.creditURL(movieId: movies[index].id).url, method: .get, headers: APIService.headers).responseDecodable(of: Credit.self){ response in
                        switch response.result {
                        case .success(let credit):
                            movies[index].credit = credit
                            dispatchGroup.leave()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(movies)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension TrendMovieInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaInfoTableViewCell.identifier, for: indexPath) as! MediaInfoTableViewCell

        cell.setData(self.list[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        vc.movie = list[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
