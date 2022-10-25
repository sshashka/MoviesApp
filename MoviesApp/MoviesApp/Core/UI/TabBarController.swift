//
//  TabBarController.swift
//  MoviesApp
//
//  Created by Саша Василенко on 12.10.2022.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        tabBar.tintColor = .label
    }
    
    private func setupVC() {
        viewControllers = [createNavVC(for: HomeScreenViewController.module, title: "Home", image: UIImage(systemName: "house")!, navTitle: "Home"), createNavVC(for: SearchViewController.module, title: "Search", image: UIImage(systemName: "magnifyingglass")!, navTitle: "Search")]
    }
    
    private func createNavVC(for rootViewController: UIViewController, title: String, image: UIImage, navTitle: String) -> UIViewController {
        let navVC = UINavigationController(rootViewController: rootViewController)
        navVC.title = navTitle
        navVC.tabBarItem.title = title
        navVC.tabBarItem.image = image
        navVC.navigationBar.prefersLargeTitles = true
        return navVC
    }
}
