//
//  MovieDeatilsTableViewCell.swift
//  MoviesApp
//
//  Created by Саша Василенко on 17.10.2022.
//

import UIKit

class MovieDeatilsTableViewCell: UITableViewCell {
    static let identifier = "MovieDeatilsTableViewCell"
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(infoLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: topAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
