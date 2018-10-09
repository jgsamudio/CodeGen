//
//  FilterSelectionHeaderViewDelegate.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Delegate for filter selection header views.
protocol FilterSelectionHeaderViewDelegate: class {

    /// Indicates that the user tapped to select filters on the given header view.
    ///
    /// - Parameter headerView: Header view the user interacted with.
    func didSelectFilters(on headerView: FilterSelectionHeaderView)

}
