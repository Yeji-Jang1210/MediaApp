//
//  GenreManager.swift
//  MediaApp
//
//  Created by 장예지 on 6/11/24.
//

import UIKit
import Alamofire

struct Genres: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}

class GenreManager {
    static var genres: [Genre] = []
    
    static func fetchData(for type: MediaAPI){
        
        APIManager.callAPI(api: type, type: Genres.self) { result in
            switch result {
            case .success(let value):
                self.genres = value.genres
            case .error(let error):
                print(error)
            }
        }
    }
}
