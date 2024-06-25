//
//  APIManager.swift
//  MediaApp
//
//  Created by 장예지 on 6/24/24.
//

import UIKit
import Alamofire

enum NetworkResult<T> {
    case success(T)
    case error(AFError)
}

class APIManager {
    private init(){}
    
    static func callAPI<T: Codable>(url: String, type: T.Type = T.self, completion: @escaping (NetworkResult<T>) -> Void){
        AF.request(url, headers: APIInfo.headers).responseDecodable(of: type) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.error(error))
            }
        }
    }
}
