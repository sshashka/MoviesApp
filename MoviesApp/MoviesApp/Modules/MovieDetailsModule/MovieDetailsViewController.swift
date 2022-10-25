//
//  MovieDetailsViewController.swift
//  MoviesApp
//
//  Created by Саша Василенко on 17.10.2022.
//

import UIKit

enum MovieDetailsTableViewSection: CaseIterable {
    case info, videos
}

class MovieDetailsViewController: UIViewController {
    var presenter: MovieDetailsPresenterProtocol?
    var movie = Int()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(MovieDeatilsTableViewCell.self, forCellReuseIdentifier: MovieDeatilsTableViewCell.identifier)
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getDetails(for: movie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private lazy var snapshot = NSDiffableDataSourceSnapshot<MovieDetailsTableViewSection, MovieDetailsModel>()
    private lazy var dataSource = UITableViewDiffableDataSource<MovieDetailsTableViewSection, MovieDetailsModel>(
        tableView: tableView,
        cellProvider: {
            (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MovieDeatilsTableViewCell.identifier,
                for: indexPath
            ) as? MovieDeatilsTableViewCell
            if let cell = cell {
                var genresString = [String]()
                for i in 0..<item.genres.count {
                    genresString.append(item.genres[i].name)
                }
                cell.infoLabel.text = String(describing: item)
                return cell
            }
            return UITableViewCell()
        }
    )
}

private extension MovieDetailsViewController {
    func setupTableView(imageURl: String) {
        let headerView = MovieDetailsTableViewHeader(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.frame.height/3))
        headerView.setImage(for: imageURl)
        tableView.tableHeaderView = headerView
        tableView.delegate = self
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MovieDetailsViewController: UITableViewDelegate {
    
}

extension MovieDetailsViewController: MovieDetailsViewProtocol {
    func showDetails(details: MovieDetailsModel) {
        setupTableView(imageURl: details.posterPath)
        snapshot.appendSections([.info])
        snapshot.appendItems([details])
        dataSource.apply(snapshot, animatingDifferences: true)
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
