//
//  HomeTabBarViewController.swift
//  ProntoChallenge
//
//  Created by Angel Trejo Flores on 9/27/19.
//  Copyright © 2019 Angel Trejo Flores. All rights reserved.
//

import Foundation
import UIKit

final class HomeTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        setViewControllersToTabViewController()
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    /// Configure the NavigationBar in TabBarViewController.
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    /// Setup the viewControllers to show in Rappi TabBarViewController.
    private func setViewControllersToTabViewController() {
        let homeMapViewController = HomeMapViewController()
        homeMapViewController.tabBarItem = UITabBarItem(title: nil,
                                                     image: UIImage(named: "mapItem"),
                                                     selectedImage: UIImage(named: ""))
        let restaurantsViewController = RestaurantsViewController()
        restaurantsViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: UIImage(named: "restaurantsItem"),
                                                        selectedImage: UIImage(named: ""))
        let tabBarList = [homeMapViewController,
                          restaurantsViewController]
        viewControllers = tabBarList
    }
    
    /// Configure the TabBar in TabBarViewController.
    private func setupTabBar() {
        tabBar.tintColor = .orangeMexican
    }
    
    /// Is called when the UIViewController does not has Memory leak/Retain cycle.
    deinit {
        #if DEBUG
        print("DashboardTabViewController NO Memory leak/Retain cycle")
        #endif
    }
}
