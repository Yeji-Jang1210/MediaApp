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
    
    static func callAPI<T: Codable>(api: MediaAPI, type: T.Type = T.self, completion: @escaping (NetworkResult<T>) -> Void){
        AF.request(api.url,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: URLEncoding(destination: .queryString),
                   headers: APIInfo.headers).responseDecodable(of: type) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.error(error))
            }
        }
    }
}
