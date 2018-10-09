//
//  FilterBuilder.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Builder for a filter screen used to adjust parameters for a displayed leaderboard.
struct FilterBuilder: Builder {

    // MARK: - Public Properties
    
    /// Theme configuration to customize the resulting filter view UI.
    let themeConfig: FilterThemeConfiguration

    /// View model for the resulting filter view.
    let viewModel: FilterViewModel

    /// Indicates if bar buttons should be added to close the view or reset filters.
    let addBarButtons: Bool

    /// Filter adjustment for the created view controller.
    let filterAdjustment: FilterAdjustment

    /// View controller that is presenting the newly built view controller.
    /// Can be notified about changes made in the newly built view controller.
    let presentingViewController: FilterViewController?

    /// Custom title for the screen used instead of the view model's title if not nil.
    let customTitle: String?

    // MARK: - Public Functions
    
    func build() -> UIViewController {
        let viewController: FilterViewController = UIStoryboard(name: "Filters", bundle: nil).instantiateViewController()
        viewController.themeConfig = themeConfig
        viewController.viewModel = viewModel
        if addBarButtons {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                                              target: viewController,
                                                                              action: #selector(FilterViewController.cancel))
            viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset",
                                                                               style: .plain,
                                                                               target: viewController,
                                                                               action: #selector(FilterViewController.reset))
        }
        viewController.presentingFilterViewController = presentingViewController
        viewController.filterAdjustment = filterAdjustment
        viewController.customTitle = customTitle

        return viewController
    }

}
