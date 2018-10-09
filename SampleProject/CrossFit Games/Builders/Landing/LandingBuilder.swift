//
//  LandingBuilder.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct LandingBuilder: Builder {

    func build() -> UIViewController {
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let viewController: LandingViewController = storyboard.instantiateViewController()
        viewController.viewModel = RootViewModel()
        return viewController
    }
}
