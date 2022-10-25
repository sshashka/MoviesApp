//
//  ViewController.swift
//  MoviesApp
//
//  Created by Саша Василенко on 13.10.2022.
//

import UIKit

class SearchViewController: UIViewController {
    private var data = SearchModuleResults()
    private var collectionView: UICollectionView?
    private var searchController = UISearchController()
    private var presenter: SearchModulePresenterProtocol!
    private var searchControllerIsActive: Bool? {
        didSet {
            searchControllerDidBecomeActive()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getRecent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.title = "Search"
    }
}

private extension SearchViewController {
    
    func setupView() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.bounds.width/3) - 10, height: (view.bounds.height/4))
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 65)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(BasicMovieCollectionViewCell.self, forCellWithReuseIdentifier: BasicMovieCollectionViewCell.identifier)
        collectionView?.register(BasicHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BasicHeaderCollectionReusableView.identifier)
        collectionView?.backgroundColor = .clear
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        setupConstraints()
        
    }
    func setupConstraints() {
        guard let collectionView = collectionView else { return }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicMovieCollectionViewCell.identifier, for: indexPath) as? BasicMovieCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell()}
        cell.nameLabel.text = data[indexPath.row].title
        if let image = data[indexPath.row].posterPath {
            cell.imageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(image)"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BasicHeaderCollectionReusableView.identifier, for: indexPath)
            guard let header = header as? BasicHeaderCollectionReusableView else { return UICollectionReusableView() }
            header.label.text = "Searched recently"
            return header
        default:
            assert(false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.addRecent(index: indexPath.row)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if searchController.isActive {
            searchControllerIsActive = false
            presenter.searchData(text: text)
        } else {
            searchControllerResignActive()
        }
        collectionView?.reloadData()
    }
    
    private func searchControllerDidBecomeActive() {
        data = []
        collectionView?.reloadData()
    }
    
    
    private func searchControllerResignActive() {
        data = []
        presenter.getRecent()
    }
}

extension SearchViewController: SearchModulePresenterViewProtocol {
    func showData(result: SearchModuleResults) {
        self.data = result
        collectionView?.reloadData()
    }
}

extension SearchViewController {
    static var module: SearchViewController {
        let service = SearchModuleService()
        let view = SearchViewController()
        let coreData = CoreDataManager()
        let presenter = SearchModulePresenter(service: service, view: view, coreDataManager: coreData)
        view.presenter = presenter
        return view
    }
}
