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
    case error(NetworkingError)
}

enum NetworkingError: Error {
    case failedRequest
    case noData
    case invalidResponse
    case invalidaData
    case badReqeust
    case forbidden
    case notFound
    case serverError
    case unownedError
}

class APIManager {
    private init(){}
    
    static func callAPI<T: Codable>(api: MediaAPI, type: T.Type, completion: @escaping (NetworkResult<T>) -> Void){
        AF.request(api.url,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: URLEncoding(destination: .queryString),
                   headers: APIInfo.headers).responseDecodable(of: T.self) { response in
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200..<400:
                    guard let data = response.data else {
                        completion(.error(.noData))
                        return
                    }
                    
                    do{
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.error(.invalidaData))
                    }
                case 400:
                    completion(.error(.badReqeust))
                case 403:
                    completion(.error(.forbidden))
                case 404:
                    completion(.error(.notFound))
                case 500..<600:
                    completion(.error(.serverError))
                default:
                    completion(.error(.unownedError))
                }
            } else {
                completion(.error(.invalidResponse))
            }
        }
    }
}
