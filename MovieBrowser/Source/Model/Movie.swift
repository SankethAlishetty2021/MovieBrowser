//
//  Movie.swift
//  MovieBrowser
//
//  Created by Sanketh on 15/11/21.
//  Copyright © 2020 Lowe's Home Improvement. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let title: String
    let rating: Double
    let posterPath: String?
    let releaseDate: String?
    let description: String
    
    private enum CodingKeys : String, CodingKey {
        case title = "original_title"
        case rating = "vote_average"
        case posterPath = "backdrop_path"
        case releaseDate = "release_date"
        case description = "overview"
        }
}
