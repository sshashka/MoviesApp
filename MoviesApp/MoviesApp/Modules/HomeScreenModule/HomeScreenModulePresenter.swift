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
}

protocol HomeScreenModulePresenterProtocol: AnyObject {
    func loadMoreFunctionDidTap()
    func movieTypeChanged(movieType: HomePageMovieType)
    func getData()
}

final class HomeScreenModulePresenter: HomeScreenModulePresenterProtocol {
    var movieType: HomePageMovieType
    private var page: Int = 1
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
        }
    }
    
    func loadMoreFunctionDidTap() {
        page += 1
        getData()
    }
    
    func movieTypeChanged(movieType: HomePageMovieType) {
        self.movieType = movieType
        service.getData(type: movieType, page: page) { [weak self] (results) in
            self?.view?.movieTypeDidChange(results: results)
        }
        
    }
}
