//
//  Video.swift
//  MediaApp
//
//  Created by 장예지 on 6/28/24.
//

import Foundation

struct Videos: Decodable {
    let results: [Video]
}

struct Video: Decodable {
    let key: String
}
