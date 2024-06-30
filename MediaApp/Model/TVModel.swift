//
//  TVModel.swift
//  MediaApp
//
//  Created by 장예지 on 6/11/24.
//

import Foundation

struct SearchResult: Codable {
    let page: Int
    let total_pages: Int
    let total_results: Int
    var results: [TVProgram]
}

struct TVProgram: Codable {
    let id: Int
    let original_name: String
    var poster_path: String?
    let vote_average: Double
    let genre_ids: [Int]
    let adult: Bool
    
    var genreText: String {
        var list: [String] = []

        for id in genre_ids {
            if let name = GenreManager.genres.filter({ $0.id == id }).map({ $0.name }).first {
                list.append(name)
            }
        }

        return list.count == 0 ? "" : "#\(list.joined(separator: " #"))"
    }
}

struct MediaPosters: Codable {
    let backdrops: [Poster]
}

struct Poster: Codable {
    let file_path: String
}
