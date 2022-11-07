//
//  SearchModuleService.swift
//  MoviesApp
//
//  Created by Саша Василенко on 17.10.2022.
//

import Foundation

protocol SearchModuleServiceProtocol: AnyObject {
    func getSearchResults(for text: String, page: Int, completion: @escaping(SearchModuleResults) -> Void)
}


final class SearchModuleService: RestService {
    func getLink(for text: String, page: Int) -> String {
        return baseURL + "/search/movie?" + token + "&language=en-US&query=" + text.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)! + "&page=\(page)&include_adult=true"
    }
}

extension SearchModuleService: SearchModuleServiceProtocol {
    
    func getSearchResults(for text: String, page: Int,completion: @escaping (SearchModuleResults) -> Void) {
        let url = URL(string: getLink(for: text, page: page))
        guard let url = url else { return }
        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let decoder = JSONDecoder()
            do {
                guard let data = data else { return }
                let result = try decoder.decode(APIArrayData<SearchModuleModel>.self, from: data)
                DispatchQueue.main.async {
                    completion(result.results)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
