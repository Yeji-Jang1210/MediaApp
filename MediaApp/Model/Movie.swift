//
//  Movie.swift
//  MediaApp
//
//  Created by 장예지 on 6/10/24.
//

import Foundation

struct TrendMovie: Codable {
    let page: Int
    var results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let original_title: String
    let backdrop_path: String
    let poster_path: String
    let release_date: String
    let overview: String
    let vote_average: Double
    let genre_ids: [Int]
    var credit: Credit?
    
    var genreText: String {
        var list: [String] = []

        for id in genre_ids {
            if let name = GenreManager.genres.filter({ $0.id == id }).map({ $0.name }).first {
                list.append(name)
            }
        }

        return "#\(list.joined(separator: " #"))"
    }
}

struct Credit: Codable {
    let cast: [Cast]
    var castText: String {
        return cast.map{$0.name}.joined(separator: ", ")
    }
}

struct Cast: Codable {
    let name: String
    let character: String
    let profile_path: String?
}

struct Genres: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
