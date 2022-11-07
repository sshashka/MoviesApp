//
//  HomeScreenService.swift
//  MoviesApp
//
//  Created by Саша Василенко on 12.10.2022.
//

import Foundation
import SDWebImage

typealias Pictures = [Data]

protocol HomeScreenServiceProtocol: AnyObject {
    func getData(type: HomePageMovieType, page: Int, completion: @escaping(HomePageResults) -> Void)
    func downloadPictures(link: String, completion: @escaping(SDWebImageDownloadToken) -> Void)
}

final class HomeScreenService: RestService {
    func linkString(type: HomePageMovieType, page: Int) -> String {
        return baseURL + "/movie/\(type.urlName)?" + token + "&language=en-US&page=\(page)"
    }
    func linkStringForPictures(links: String) -> String {
        var link = String()
        link = basePicURL + links
        return link
    }
}

extension HomeScreenService: HomeScreenServiceProtocol {
    func getData(type: HomePageMovieType ,page: Int, completion: @escaping (HomePageResults) -> Void) {
        let url = URL(string: linkString(type: type, page: page))
        guard let url = url else { return }
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let decoder = JSONDecoder()
            do {
                guard let data = data else { return }
                let result = try decoder.decode(APIArrayData<HomePageModel>.self, from: data)
                DispatchQueue.main.async {
                    completion(result.results)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    func downloadPictures(link: String, completion: @escaping(SDWebImageDownloadToken) -> Void) {
        let url = URL(string: linkStringForPictures(links: link))
        let picture = SDWebImageDownloader.shared.downloadImage(with: url)
        guard let picture = picture else { return }
        completion(picture)
    }
    
}
