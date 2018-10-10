//
//  TabBarDataSource.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Data source for a tab bar item.
protocol TabBarDataSource {

    /// The tab bar title for a given view controller.
    ///
    /// - Returns: The string for the tab bar title.
    func tabBarItemTitle() -> String

    /// Tab bar icon for a given view controller
    ///
    /// - Returns: Selected and unselected UIImage for the tab bar icon
    func tabBarIcon() -> (selected: UIImage?, unselected: UIImage?)
}
