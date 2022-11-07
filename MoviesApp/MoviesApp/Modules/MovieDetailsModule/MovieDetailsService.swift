//
//  MovieDetailsService.swift
//  MoviesApp
//
//  Created by Саша Василенко on 21.10.2022.
//

import Foundation

protocol MovieDetailsServiceProtocol: AnyObject {
    func getDetails(for movie: Int, completion: @escaping(MovieDetailsModel) -> Void)
    func getTrailers(for movie: Int, completion: @escaping(VideosData) -> Void)
}

final class MovieDetailsService: RestService {
    func getLink(for movie: Int) -> String {
        return baseURL + "/movie/\(movie)?" + token + "&language=en-US"
    }
    
    func getVideosLink(for movie: Int) -> String {
        return baseURL + "/movie/\(movie)/videos?" + token + "&language=en-US"
    }
}

extension MovieDetailsService: MovieDetailsServiceProtocol {
    func getDetails(for movie: Int, completion: @escaping (MovieDetailsModel) -> Void) {
        let url = URL(string: getLink(for: movie))
        guard let url = url else { return }
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            do {
                guard let data = data else { return }
                let result = try JSONDecoder().decode(MovieDetailsModel.self, from: data)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getTrailers(for movie: Int, completion: @escaping(VideosData) -> Void) {
        let url = URL(string: getVideosLink(for: movie))
        guard let url = url else { return }
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                guard let data = data else { return }
                let result = try decoder.decode(APIArrayVideosData<MovieVideosModel>.self, from: data)
                completion(result.results)
            } catch {
                print(error)
            }
        }.resume()
    }
}
