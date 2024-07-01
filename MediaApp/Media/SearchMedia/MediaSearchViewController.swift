//
//  MediaSearchViewController.swift
//  MediaApp
//
//  Created by 장예지 on 6/11/24.
//

import UIKit

import Alamofire
import SnapKit
import Kingfisher

class MediaSearchViewController: BaseVC {
    //MARK: - object
    let backView: UIView = {
        let object = UIView()
        object.clipsToBounds = true
        object.backgroundColor = .white
        return object
    }()
    
    let textField: UITextField = {
        let object = UITextField()
        object.borderStyle = .none
        object.font = .systemFont(ofSize: 14)
        object.attributedPlaceholder = NSAttributedString(string: "검색할 TV 프로그램을 입력해주세요", attributes: [.foregroundColor: UIColor.darkGray, .font: UIFont.systemFont(ofSize: 12)])
        object.textColor = .black
        return object
    }()
    
    let searchButton: UIButton = {
        let object = UIButton(type: .system)
        object.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        object.tintColor = .black
        return object
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.backgroundColor = .clear
        return object
    }()
    
    let topButton: UIButton = {
        let object = UIButton(type: .system)
        object.setBackgroundImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        object.tintColor = .black
        return object
    }()
    
    //MARK: - properties
    var list: SearchResult?
    var page: Int = 1
    var isEnd: Bool {
        if let totalPage = list?.total_pages {
            if totalPage == page {
                return true
            }
        }
        return false
    }
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        view.addSubview(backView)
        view.addSubview(collectionView)
        view.addSubview(topButton)
        
        backView.addSubview(textField)
        backView.addSubview(searchButton)
    }
    
    override func configureLayout(){
        backView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(60)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(backView.snp.leading).offset(20)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        searchButton.snp.makeConstraints { make in
            make.leading.equalTo(textField.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(25)
            make.centerY.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        topButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(60)
        }
    }
    
    override func configureUI(){
        configureCollectionView()
        backView.layoutIfNeeded()
        backView.layer.cornerRadius = backView.bounds.height / 2
    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    //MARK: - function
    private func bindAction(){
        GenreManager.fetchData(for: MediaAPI.tvGenreURL)
        
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        topButton.addTarget(self, action: #selector(topButtonTapped), for: .touchUpInside)
    }
    
    private func callAPI(text: String){
        APIManager.callAPI(api: MediaAPI.searchURL(text: text, page: self.page), type: SearchResult.self) { result in
            switch result {
            case .success(let value):
                if self.page == 1 {
                    self.list = value
                } else {
                    self.list?.results.append(contentsOf: value.results)
                }
                
                self.collectionView.reloadData()
                
                if self.page == 1 && !value.results.isEmpty {
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            case .error(let error):
                print(error)
            }
        }
    }
    
    @objc func searchButtonTapped(){
        guard let text = textField.text, !text.isEmpty else { return }
        
        view.endEditing(true)
        
        page = 1
        callAPI(text: text)
    }
    
    @objc func topButtonTapped(){
        if let isEmpty = list?.results.isEmpty, !isEmpty {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

extension MediaSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 10
        return CGSize(width: width / 2, height: (width / 2) * 1.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        if let data = list?.results[indexPath.row] {
            cell.fetchData(data: data)
            return cell
        }
        
        return cell
    }
}

extension MediaSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let count = list?.results.count {
                if count - 2 == indexPath.row && !isEnd {
                    page += 1
                    callAPI(text: textField.text!)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let program = list?.results[indexPath.row] {
            let vc = TVDetailViewController(id: program.id, title: program.original_name)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
