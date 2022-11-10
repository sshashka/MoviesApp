//
//  HomeScreenModulePresenter.swift
//  MoviesApp
//
//  Created by Саша Василенко on 20.10.2022.
//

import Foundation
protocol HomeScreenModuleViewProtocol: AnyObject {
    func showResults(results: HomePageResults)
    func movieTypeDidChange(results: HomePageResults)
    func movieFilterDidChange(results: HomePageResults)
}

protocol HomeScreenModulePresenterProtocol: AnyObject {
    func loadMoreFunctionDidTap()
    func movieTypeChanged(movieType: HomePageMovieType)
    func getData()
    func sortMovies(type: SortingTypes)
}

enum SortingTypes {
    case byReleaseDate, byPopularity, standart, byRating
}

final class HomeScreenModulePresenter: HomeScreenModulePresenterProtocol {
    var movieType: HomePageMovieType
    private var page: Int = 1
    var data: HomePageResults?
    
    let service: HomeScreenServiceProtocol!
    weak var view: HomeScreenModuleViewProtocol?
    
    init(service: HomeScreenServiceProtocol, view: HomeScreenModuleViewProtocol?, movieType: HomePageMovieType) {
        self.service = service
        self.view = view
        self.movieType = movieType
    }
    
    func getData() {
        service.getData(type: movieType, page: page) {[weak self] (results) in
            self?.view?.showResults(results: results)
            self?.data = results
        }
    }
    
    func loadMoreFunctionDidTap() {
        page += 1
        getData()
    }
    
    func sortMovies(type: SortingTypes) {
        guard let data = data else { return }
        var sortedData: HomePageResults
        switch type {
        case .byReleaseDate:
            sortedData = data.sorted(by: {
                $0.releaseDate < $1.releaseDate
            })
        case .byPopularity:
            sortedData = data.sorted(by: {
                $0.popularity > $1.popularity
            })
        case .byRating:
            sortedData = data.sorted(by: {
                $0.voteAverage > $1.voteAverage
            })
        case .standart:
            sortedData = data
        }
        view?.movieFilterDidChange(results: sortedData)
    }
    
    func movieTypeChanged(movieType: HomePageMovieType) {
        self.movieType = movieType
        service.getData(type: movieType, page: page) { [weak self] (results) in
            self?.view?.movieTypeDidChange(results: results)
        }
    }
}
