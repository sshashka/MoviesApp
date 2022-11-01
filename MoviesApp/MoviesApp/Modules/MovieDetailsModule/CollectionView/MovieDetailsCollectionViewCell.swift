//
//  MovieDetailsCollectionViewCell.swift
//  MoviesApp
//
//  Created by Саша Василенко on 17.10.2022.
//

import UIKit

final class MovieDetailsCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieDetailsCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8.0
        return imageView
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("Inited \(type(of: self))")
        contentView.addSubview(imageView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(link: String) {
        let url = URL(string: GlobalVariables.youtubePicURL.rawValue + link + "/0.jpg")
        imageView.sd_setImage(with: url)
    }
        
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
}
