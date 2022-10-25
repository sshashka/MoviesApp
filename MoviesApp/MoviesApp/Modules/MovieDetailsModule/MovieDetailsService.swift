//
//  MovieDetailsService.swift
//  MoviesApp
//
//  Created by Саша Василенко on 21.10.2022.
//

import Foundation

protocol MovieDetailsServiceProtocol: AnyObject {
    func getDetails(for movie: Int, completion: @escaping(MovieDetailsModel) -> Void)
}

class MovieDetailsService: RestService {
    func getLink(for movie: Int) -> String {
        return baseURL + "/movie/\(movie)?" + token + "&language=en-US"
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
}
