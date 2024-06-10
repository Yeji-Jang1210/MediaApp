//
//  GenreManager.swift
//  MediaApp
//
//  Created by 장예지 on 6/11/24.
//

import UIKit
import Alamofire

class GenreManager {
    static var genres: [Genre] = []
    
    static func fetchData(){
        AF.request(MediaAPI.genreURL.url, method: .get, headers: APIService.headers).responseDecodable(of: Genres.self) { response in
            switch response.result {
            case .success(let value):
                self.genres = value.genres
            case .failure(let error):
                print(error)
            }
        }
    }
}
