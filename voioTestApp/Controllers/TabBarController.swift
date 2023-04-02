//
//  ViewController.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 29.03.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfigurations()
        setupVCs()
    }
    //MARK: Methods
    private func defaultConfigurations() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
    }
    
    private func setupVCs() {
        viewControllers = [
            createNavController(for: HomeViewController(), navBarTitle: "Movies", tabBarTitle: "Home", image: UIImage(systemName: "house") ?? UIImage()),
            createNavController(for: FavouritesViewController(), navBarTitle: "Favourites", tabBarTitle: "Favourites", image: UIImage(systemName: "star.fill") ?? UIImage()),
            createNavController(for: ProfileViewController(), navBarTitle: "Profile", tabBarTitle: "Profile", image: UIImage(systemName: "person") ?? UIImage())
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController,
                                     navBarTitle: String,
                                     tabBarTitle: String,
                                     image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = tabBarTitle
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = navBarTitle
        return navController
    }
}

