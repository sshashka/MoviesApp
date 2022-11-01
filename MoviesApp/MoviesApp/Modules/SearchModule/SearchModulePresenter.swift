//
//  SearchModulePresenter.swift
//  MoviesApp
//
//  Created by Саша Василенко on 20.10.2022.
//

import Foundation

protocol SearchModulePresenterViewProtocol: AnyObject {
    func showData(result: SearchModuleResults)
}

protocol SearchModulePresenterProtocol: AnyObject {
    func searchData(text: String)
    func getRecent()
    func addRecent(index: Int)
}

class SearchModulePresenter: SearchModulePresenterProtocol {
    
    let service: SearchModuleServiceProtocol!
    let coreDataManager: CoreDataManagerProtocol!
    var data: SearchModuleResults?
    weak var view: SearchModulePresenterViewProtocol?
    init(service: SearchModuleServiceProtocol, view: SearchModulePresenterViewProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
        self.service = service
        self.view = view
    }
    
    func searchData(text: String) {
        service.getSearchResults(for: text, page: 1) {[weak self] (result) in
            self?.view?.showData(result: result)
            self?.data = result
        }
    }
    
    func getRecent() {
        var sas: SearchModuleResults = []
        let data = coreDataManager.getSearchedMovies()
        guard let data = data else { return }
        for i in 0..<data.count {
            if let storedData = data[i].dataFromApi {
                let result = try? PropertyListDecoder.init().decode(SearchModuleModel.self, from: storedData)
                guard let result = result else { return }
                sas.append(result)
            }
            
        }
        view?.showData(result: sas)
    }
    
    func addRecent(index: Int) {
        let data = try? PropertyListEncoder.init().encode(data?[index])
        guard let data = data else { return }
        coreDataManager.save(for: data)
        print(data)
    }
}
