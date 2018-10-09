//
//  CardDetailContainerViewModel.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/13/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// View model for a card detail view container.
struct CardDetailContainerViewModel {

    /// View controllers to be displayed in the associated view controller.
    let viewControllers: [UIViewController]

    /// Index of the first view to be shown when presenting the view controller.
    var initialViewIndex: Int

}
