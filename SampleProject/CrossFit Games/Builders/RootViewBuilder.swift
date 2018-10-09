//
//  RootViewBuilder.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/16/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct RootViewBuilder: Builder {

    // MARK: - Public Properties
    
    let viewModel = RootViewModel()

    // MARK: - Public Functions
    
    func build() -> UIViewController {
        if viewModel.isLoggedIn {
            return MainNavigationBuilder().build()
        } else {
            return UINavigationController(rootViewController: LandingBuilder().build())
        }
    }

    func logout() {
        viewModel.logout()
    }

}
