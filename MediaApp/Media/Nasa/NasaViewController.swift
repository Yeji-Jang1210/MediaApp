//
//  NasaViewController.swift
//  MediaApp
//
//  Created by 장예지 on 7/1/24.
//

import UIKit
import SnapKit

//final로 더이상 상속을 받지 않는 클래스임을 명시!
final class NasaViewController: BaseVC {
    
    private enum Nasa: String, CaseIterable {
        
        static let baseURL = "https://apod.nasa.gov/apod/image/"
        
        case one = "2308/sombrero_spitzer_3000.jpg"
        case two = "2212/NGC1365-CDK24-CDK17.jpg"
        case three = "2307/M64Hubble.jpg"
        case four = "2306/BeyondEarth_Unknown_3000.jpg"
        case five = "2307/NGC6559_Block_1311.jpg"
        case six = "2304/OlympusMons_MarsExpress_6000.jpg"
        case seven = "2305/pia23122c-16.jpg"
        case eight = "2308/SunMonster_Wenz_960.jpg"
        case nine = "2307/AldrinVisor_Apollo11_4096.jpg"
         
        static var photo: URL {
            return URL(string: Nasa.baseURL + Nasa.allCases.randomElement()!.rawValue)!
        }
    }
    
    private enum NasaAPIError: Error {
        case invalidValue
        case invalidResponse
        case invalidImage
        case completeWithError
        case unownedError
        
        var title: String {
            return "오류"
        }
        
        var message: String {
            switch self {
            case .invalidValue:
                return "정보를 불러오는데 실패했습니다."
            case .invalidResponse:
                return "서버로부터 잘못된 응답을 받았습니다."
            case .invalidImage:
                return "이미지를 로드하는데 실패했습니다."
            case .completeWithError:
                return "나중에 다시 시도해 주세요"
            case .unownedError:
                return "알 수 없는 오류가 발생했습니다."
            }
        }
    }
    
    let imageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFill
        return object
    }()
    
    let requestButton: UIButton = {
        var configure = UIButton.Configuration.plain()
        configure.background.backgroundColor = .white
        configure.attributedTitle = AttributedString("클릭", attributes: AttributeContainer([.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 14)]))
        configure.cornerStyle = .capsule
        
        let object = UIButton(configuration: configure)
        return object
    }()
    
    let progressBackgroundView: UIView = {
        let object = UIView()
        object.backgroundColor = .black.withAlphaComponent(0.3)
        object.isHidden = true
        return object
    }()
    
    let progressBar: UIProgressView = {
        let object = UIProgressView()
        object.tintColor = .white
        object.progressTintColor = .green
        object.setProgress(0, animated: false)
        return object
    }()
    
    let loadFailedView: UIView = {
        let object = UIView()
        object.isHidden = true
        return object
    }()
    
    let loadFailedImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFit
        object.image = UIImage(systemName: "exclamationmark.triangle")
        object.tintColor = .lightGray
        return object
    }()
    
    let loadFailedLabel: UILabel = {
        let object = UILabel()
        object.text = "이미지를 불러오는데 실패했습니다."
        object.textColor = .lightGray
        return object
    }()
    
    var session: URLSession!
    
    var buffer: Data? {
        didSet {
            if let count = buffer?.count, count != 0 {
                let percent = (Double(count) / total)
                print(Float(percent))
                progressBar.setProgress(Float(percent), animated: true)
            }
        }
    }
    
    var total: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        view.addSubview(imageView)
        view.addSubview(loadFailedView)
        view.addSubview(requestButton)
        view.addSubview(progressBackgroundView)
        
        progressBackgroundView.addSubview(progressBar)
        
        loadFailedView.addSubview(loadFailedImageView)
        loadFailedView.addSubview(loadFailedLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        requestButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        progressBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        progressBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.center.equalToSuperview()
        }
        
        loadFailedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadFailedImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(50)
            make.size.equalTo(120)
        }
        
        loadFailedLabel.snp.makeConstraints { make in
            make.top.equalTo(loadFailedImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        requestButton.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
        
    }
    
    @objc
    func requestButtonTapped(){
        progressBackgroundView.isHidden = false
        loadFailedView.isHidden = true
        progressBar.setProgress(0, animated: false)
        callAPI()
    }
    
    private func callAPI(){
        buffer = Data()
        
        let request = URLRequest(url: Nasa.photo)
        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        session.dataTask(with: request).resume()
    }
    
    private func errorHandler(error: NasaAPIError){
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "확인", style: .cancel) { _ in
            self.progressBackgroundView.isHidden = true
            self.loadFailedView.isHidden = false
            self.progressBar.setProgress(0, animated: false)
        }
        
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}

extension NasaViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode){
            guard let value = response.value(forHTTPHeaderField: "Content-Length"), let totalValue = Double(value) else {
                errorHandler(error: .invalidValue)
                return .cancel
            }
            total = totalValue
            return .allow
        }
        
        errorHandler(error: .invalidResponse)
        return .cancel
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer?.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        if let error = error {
            errorHandler(error: .completeWithError)
        } else {
            guard let buffer = buffer, let image = UIImage(data: buffer) else {
                errorHandler(error: .invalidImage)
                return
            }
            
            progressBackgroundView.isHidden = true
            imageView.image = image
        }
    }
}
