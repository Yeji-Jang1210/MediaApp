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

enum MediaType {
    case movie
    case tv
}

class GenreManager {
    static var genres: [Genre] = []
    
    static func fetchData(for type: MediaType){
        let url: String
        switch type {
        case .movie:
            url = MediaAPI.movieGenreURL.url
        case .tv:
            url = MediaAPI.tvGenreURL.url
        }
        
        APIManager.callAPI(url: url, type: Genres.self) { result in
            switch result {
            case .success(let value):
                self.genres = value.genres
            case .error(let error):
                print(error)
            }
        }
    }
}
