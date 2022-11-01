//
//  MovieVideosModel.swift
//  MoviesApp
//
//  Created by Саша Василенко on 02.11.2022.
//

import Foundation

typealias VideosData = [MovieVideosModel] 
struct MovieVideosModel: Codable {
    let iso639_1, iso3166_1: String?
    let name, key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt, id: String
}
