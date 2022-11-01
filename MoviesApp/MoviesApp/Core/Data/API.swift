//
//  Api.swift
//  MoviesApp
//
//  Created by Саша Василенко on 12.10.2022.
//

import Foundation

struct HomePageMovieType {
    let urlName: String
    
    static let topRated = HomePageMovieType(urlName: "top_rated")
    static let nowPlaying = HomePageMovieType(urlName: "now_playing")
}

class RestService {
    let baseURL = "https://api.themoviedb.org/3"
    let basePicURL = "https://image.tmdb.org/t/p/w500/"
    let token = "api_key=5fcd48ff18df9c4be1bbe8d40c555520"
}

struct APIArrayData<Data: Codable>: Codable {
    let page: Int?
    let results: [Data]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct APIArrayVideosData<Data: Codable>: Codable {
    let id: Int
    let results: [Data]
}
