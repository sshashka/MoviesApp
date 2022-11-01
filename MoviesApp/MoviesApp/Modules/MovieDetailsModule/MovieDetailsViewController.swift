//
//  MovieDetailsViewController.swift
//  MoviesApp
//
//  Created by Саша Василенко on 17.10.2022.
//

import UIKit
import Lottie

enum MovieDetailsTableViewSection: Int, CaseIterable {
    case info, videos
}

final class MovieDetailsViewController: UIViewController {
    private var presenter: MovieDetailsPresenterProtocol?
    var movie = Int()
    private var data = [MovieDetailsModel]()
    private var trailers = VideosData()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.backgroundView = CommonUICollorsAndViews.getbasicBlurEffect()
        tableView.register(MovieDeatilsTableViewCell.self, forCellReuseIdentifier: MovieDeatilsTableViewCell.identifier)
        tableView.register(MovieVideosTableViewCell.self, forCellReuseIdentifier: MovieVideosTableViewCell.identifier)
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getDetails(for: movie)
        presenter?.getTrailers(for: movie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(CommonUICollorsAndViews.getLottieBackground())
        view.addSubview(tableView)
        setupConstraints()
    }
    
    deinit {
        print("deinited \(type(of: self))")
    }
}

private extension MovieDetailsViewController {
    func setupTableView(imageURl: String) {
        let headerView = MovieDetailsTableViewHeader(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.frame.height/3))
        headerView.setImage(for: imageURl)
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureVideosCell(for cell: MovieVideosTableViewCell) {
        cell.data = trailers
    }
}

extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        MovieDetailsTableViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == MovieDetailsTableViewSection.info.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDeatilsTableViewCell.identifier, for: indexPath) as? MovieDeatilsTableViewCell
            guard let cell = cell else { return UITableViewCell() }
            cell.infoLabel.text = data[indexPath.row].title
            return cell
        } else if indexPath.section == MovieDetailsTableViewSection.videos.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieVideosTableViewCell.identifier, for: indexPath) as? MovieVideosTableViewCell
            guard let cell = cell else { return UITableViewCell() }
            configureVideosCell(for: cell)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == MovieDetailsTableViewSection.info.rawValue {
            return UITableView.automaticDimension
        } else if indexPath.section == MovieDetailsTableViewSection.videos.rawValue {
            return 210
        }
        return UITableView.automaticDimension
    }
}

extension MovieDetailsViewController: MovieDetailsViewProtocol {
    
    func showDetails(details: MovieDetailsModel) {
        setupTableView(imageURl: details.posterPath)
        self.data.append(details)
        tableView.reloadData()
    }
    func showTrailers(trailers: VideosData) {
        self.trailers.append(contentsOf: trailers)
    }
}

extension MovieDetailsViewController {
    static var module: MovieDetailsViewController {
        let service = MovieDetailsService()
        let view = MovieDetailsViewController()
        let presenter = MovieDetailsPresenter(service: service, view: view)
        view.presenter = presenter
        return view
    }
}
