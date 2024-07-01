//
//  YoutubeWebViewController.swift
//  MediaApp
//
//  Created by 장예지 on 7/1/24.
//

import UIKit
import WebKit

import SnapKit

class YoutubeWebViewController: UIViewController {
    let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    var url: String = ""
    
    init(url: String){
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            
            webView.load(request)
        }
    }
}
