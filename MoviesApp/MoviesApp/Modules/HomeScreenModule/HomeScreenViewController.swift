//
//  ViewController.swift
//  MoviesApp
//
//  Created by Саша Василенко on 12.10.2022.
//

import UIKit
import SDWebImage
import Lottie

final class HomeScreenViewController: UIViewController {
    private var results = HomePageResults()
    private var movieType: HomePageMovieType = .topRated
    private var page = 1
    private var presenter: HomeScreenModulePresenterProtocol?
    private var animationView: LottieAnimationView!
    
    private var collectionView: UICollectionView! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        animationView = CommonUICollorsAndViews.getLottieBackground()
        view.addSubview(animationView)
        self.title = "Home"
        setupCollectionView()
        setupConstraints()
        setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
        presenter?.getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        present(AutorizationViewController(), animated: true)
        animationView.stop()
        WebImageManager.shared.removeCache()
    }
}

private extension HomeScreenViewController {
    func displayData(results: HomePageResults, pictures: Pictures?) {
        self.results = results
        collectionView.reloadData()
    }
    func setupCollectionView() {
        let layuot = UICollectionViewFlowLayout()
        layuot.scrollDirection = .vertical
        layuot.itemSize = CGSize(width: (view.bounds.width/2) - 10, height: (view.bounds.height/5) - 30)
        layuot.footerReferenceSize = CGSize(width: view.bounds.width, height: 66.0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layuot)
        guard let collectionView = collectionView else { return }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.backgroundView = nil
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BasicMovieCollectionViewCell.self, forCellWithReuseIdentifier: BasicMovieCollectionViewCell.identifier)
        collectionView.register(HomePageCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomePageCollectionReusableView.identifier)
        view.addSubview(collectionView)
    }
    
    func animateChanges() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseIn], animations: {
            //dont need [weak self] here becuse it
            self.collectionView.reloadSections(IndexSet(integersIn: 0...0))
        }, completion: nil)
    }
    
    func setupNavBar() {
        let typeButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down")!, style: .plain, target: self, action: #selector(cinemaTypeDidTap))
        
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "list.dash")!, style: .plain, target: self, action: #selector(sortButtonDidTap))
        
        navigationItem.rightBarButtonItems = [typeButton, sortButton]
    }
    //MARK: Actiongs for sorting
    @objc func sortButtonDidTap() {
        let alert = UIAlertController(title: "Sorting types", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .label
        alert.addAction(UIAlertAction(title: "By release date", style: .default, handler: byReleaseDateDidTap))
        alert.addAction(UIAlertAction(title: "By popularity", style: .default, handler: byPopularityDidTap))
        alert.addAction(UIAlertAction(title: "By rating", style: .default, handler: byRatingDidTap))
        alert.addAction(UIAlertAction(title: "Default", style: .default, handler: byDefaultDidTap))
        alert.addAction(UIAlertAction(title: "Cancell", style: .cancel))
        
        present(alert, animated: true)
    }
    //MARK: Actiongs for cinema types
    @objc func cinemaTypeDidTap() {
        let alert = UIAlertController(title: "Select cinema type", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .label
        let actionTopRated = UIAlertAction(title: "Top Rated", style: .default, handler: topRatedActionDidTap)
        let actionNowPlaying = UIAlertAction(title: "Now playing", style: .default, handler: nowPlayingActionDidTap)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(actionTopRated)
        alert.addAction(actionNowPlaying)
        alert.addAction(actionCancel)
        
        present(alert, animated: true)
    }
    
    //MARK: Handlers for cinema types
    func topRatedActionDidTap(_ action: UIAlertAction) {
        presenter?.movieTypeChanged(movieType: .topRated)
    }
    
    func nowPlayingActionDidTap(_ action: UIAlertAction) {
        presenter?.movieTypeChanged(movieType: .nowPlaying)
    }
    //MARK: Handlers for sorting
    
    func byReleaseDateDidTap(_ action: UIAlertAction) {
        presenter?.sortMovies(type: .byReleaseDate)
    }
    
    func byDefaultDidTap(_ action: UIAlertAction) {
        presenter?.sortMovies(type: .standart)
    }
    
    func byPopularityDidTap(_ action: UIAlertAction) {
        presenter?.sortMovies(type: .byPopularity)
    }
    
    func byRatingDidTap(_ action: UIAlertAction) {
        presenter?.sortMovies(type: .byRating)
    }
    
    @objc func loadMoreButtonDidTap() {
        presenter?.loadMoreFunctionDidTap()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicMovieCollectionViewCell.identifier, for: indexPath) as? BasicMovieCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        cell.nameLabel.text = results[indexPath.row].title
        cell.imageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\( results[indexPath.row].posterPath)"))
        cell.releaseLabel.text = results[indexPath.row].releaseDate
        cell.genresLabel.text = String(results[indexPath.row].voteAverage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomePageCollectionReusableView.identifier, for: indexPath)
            guard let footer = footer as? HomePageCollectionReusableView else { return UICollectionReusableView() }
            footer.button.addTarget(self, action: #selector(loadMoreButtonDidTap), for: .touchUpInside)
            return footer
        default:
            assert(false, "Invalid element type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailsViewController.module
        vc.movie = results[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeScreenViewController: HomeScreenModuleViewProtocol {
    func movieFilterDidChange(results: HomePageResults) {
        self.results = results
        animateChanges()
    }
    
    func movieTypeDidChange(results: HomePageResults) {
        self.results = results
        animateChanges()
    }
    
    func showResults(results: HomePageResults) {
        self.results.append(contentsOf: results) 
        collectionView.reloadData()
    }
}

extension HomeScreenViewController {
    static var module: HomeScreenViewController {
        let service = HomeScreenService()
        let vc = HomeScreenViewController()
        let presenter = HomeScreenModulePresenter(service: service, view: vc, movieType: .nowPlaying)
        vc.presenter = presenter
        return vc
    }
}
