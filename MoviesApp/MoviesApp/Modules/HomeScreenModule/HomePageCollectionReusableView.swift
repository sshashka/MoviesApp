//
//  HomePageCollectionReusableView.swift
//  MoviesApp
//
//  Created by Саша Василенко on 12.10.2022.
//

import UIKit

class HomePageCollectionReusableView: UICollectionReusableView {
    static let identifier = "HomePageCollectionReusableView"
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Load more", for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .tertiaryLabel
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
