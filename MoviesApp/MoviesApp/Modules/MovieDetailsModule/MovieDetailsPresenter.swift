//
//  MovieDetailsPresenter.swift
//  MoviesApp
//
//  Created by Саша Василенко on 21.10.2022.
//

import Foundation

protocol MovieDetailsViewProtocol: AnyObject {
    func showDetails(details: MovieDetailsModel)
}

protocol MovieDetailsPresenterProtocol: AnyObject {
    func getDetails(for movie: Int)
}

class MovieDetailsPresenter: MovieDetailsPresenterProtocol {
    let service: MovieDetailsServiceProtocol!
    weak var view: MovieDetailsViewProtocol?
    
    init(service: MovieDetailsServiceProtocol, view: MovieDetailsViewProtocol) {
        self.service = service
        self.view = view
    }
    
    func getDetails(for movie: Int) {
        service.getDetails(for: movie) { [weak self] (result) in
            self?.view?.showDetails(details: result)
        }
    }
}
