//
//  MovieDetailsCollectionViewCell.swift
//  MoviesApp
//
//  Created by Саша Василенко on 17.10.2022.
//

import UIKit

class MovieDetailsCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieDetailsCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "aaa")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("Inited \(type(of: self))")
        addSubview(imageView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
}
