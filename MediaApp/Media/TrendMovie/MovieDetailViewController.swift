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

final class MovieDetailViewController: BaseVC {
    
    //MARK: - object
    let tableView: UITableView = {
        let object = UITableView(frame: .zero, style: .grouped)
        object.backgroundColor = .black
        return object
    }()
    
    let headerView: UIView = {
        let object = UIView()
        return object
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return object
    }()
    
    let dismissButton: UIButton = {
        let object = UIButton()
        object.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        object.tintColor = .white
        return object
    }()
    
    let infoView: MovieInfoView = {
        let object = MovieInfoView()
        return object
    }()
    
    //MARK: - properties
    var movie: Movie? {
        didSet {
            guard let movie else { return }
            infoView.titleLabel.text = "\(movie.original_title)\n\(movie.extractedYear)"
            infoView.starRatingView.rating = movie.vote_average / 2
        }
    }
    
    var posters: [Poster]?
    
    var isExpanded: Bool = false {
        didSet {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    var currentPosterPage: Int = 0
    
    var posterLoopTimer: Timer?
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMoviePosters()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        posterLoopTimer?.invalidate()
        posterLoopTimer = nil
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        view.addSubview(tableView)
        view.addSubview(dismissButton)
        
        headerView.addSubview(collectionView)
        headerView.addSubview(infoView)
    }
    
    override func configureLayout(){
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.size.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        infoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureUI(){
        configureNavigation()
        configureTableView()
        configureHeaderCollectionView()
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    private func configureNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func configureTableView(){
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorColor = .white
        tableView.register(CastTableViewCell.self, forCellReuseIdentifier: CastTableViewCell.identifier)
        tableView.register(ExpandTextViewCell.self, forCellReuseIdentifier: ExpandTextViewCell.identifier)
    }
    
    private func configureHeaderCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieDetailViewPosterCollectionViewCell.self, forCellWithReuseIdentifier: MovieDetailViewPosterCollectionViewCell.identifier)
    }
    
    
    //MARK: - function
    @objc func expandOverViewLabel(){
        isExpanded.toggle()
    }
    
    @objc func dismissButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    private func fetchMoviePosters(){
        guard let id = movie?.id else { return }
        
        DispatchQueue.global().async {
            APIManager.callAPI(api: MediaAPI.getPostersURL(type: .movie, id: id), type: MediaPosters.self) { result in
                switch result {
                case .success(let data):
                    self.posters = data.backdrops
                    DispatchQueue.main.async{
                        
                        self.collectionView.reloadData()
                        self.startPosterLoop()
                    }
                case .error(let error):
                    print(error)
                }
            }
        }
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height / 1.4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        } else {
            let width = UIScreen.main.bounds.width / 2 - 10
            let imageHeight = width * 1.2
            
            return imageHeight + 40
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
            cell.casters = movie?.credit?.cast
            cell.collectionView.reloadData()
            return cell
        }
        
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie?.poster_path.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailViewPosterCollectionViewCell.identifier, for: indexPath) as! MovieDetailViewPosterCollectionViewCell
        print("here")
        cell.loadPosterImage(path: posters?[indexPath.row].file_path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func startPosterLoop(){
        posterLoopTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            self.moveNextBanner()
        }
    }
    
    func moveNextBanner(){
        let itemCount = collectionView.numberOfItems(inSection: 0)
        let targetIndex = currentPosterPage + 1
        
        print("\(targetIndex)")
        if targetIndex < itemCount {
            currentPosterPage += 1
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            // 선택 사항: 첫 번째 아이템으로 돌아가거나 리스트 끝을 처리
            currentPosterPage = 0
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
