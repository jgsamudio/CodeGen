//
//  CardDetailContainerBuilder.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/13/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct CardDetailContainerBuilder: Builder {

    // MARK: - Public Properties
    
    let viewModel: CardDetailContainerViewModel

    // MARK: - Public Functions
    
    func build() -> UIViewController {
        let viewController: CardDetailContainerViewController = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController()
        viewController.viewModel = viewModel

        return viewController
    }

}
