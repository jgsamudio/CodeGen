//
//  BaseAuthViewController.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/10/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Contains common functionality for auth related view controllers
class BaseAuthViewController: BaseViewController {

    private var previousNavBarStyle: NavBarStyle?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationItemTitle()
        previousNavBarStyle = navigationController.flatMap { NavBarStyle(navBar: $0.navigationBar) }
        NavBarStyle.auth.apply(to: navigationController?.navigationBar)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        /// Makes the navigation bar transparent
        navigationController?.view.backgroundColor = .clear
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        previousNavBarStyle?.apply(to: navigationController?.navigationBar)
    }

    /// Sets the navigation bar title with a custom image
    private func setNavigationItemTitle() {
        let logo = UIImage(named: "navigation bar title")
        let imageView = UIImageView(image: logo)
//        imageView.frame = CGRect(x: 0, y: 0, width: 26, height: 20)
        navigationItem.titleView = imageView
    }

}
