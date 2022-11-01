//
//  MovieDetailsPresenter.swift
//  MoviesApp
//
//  Created by Саша Василенко on 21.10.2022.
//

import Foundation

protocol MovieDetailsViewProtocol: AnyObject {
    func showDetails(details: MovieDetailsModel)
    func showTrailers(trailers: VideosData)
}

protocol MovieDetailsPresenterProtocol: AnyObject {
    func getDetails(for movie: Int)
    func getTrailers(for movie: Int)
}

class MovieDetailsPresenter: MovieDetailsPresenterProtocol {
    
    let service: MovieDetailsServiceProtocol!
    weak var view: MovieDetailsViewProtocol?
    
    init(service: MovieDetailsServiceProtocol, view: MovieDetailsViewProtocol) {
        self.service = service
        self.view = view
    }
    
    deinit {
        print("deinited \(type(of: self))")
    }
    
    func getDetails(for movie: Int) {
        service.getDetails(for: movie) { [weak self] (result) in
            self?.view?.showDetails(details: result)
        }
    }
    
    func getTrailers(for movie: Int) {
        service.getTrailers(for: movie) { [weak self] (result) in
            self?.view?.showTrailers(trailers: result)
        }
    }
}
