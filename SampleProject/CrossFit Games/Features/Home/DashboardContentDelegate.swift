//
//  DashboardContentDelegate.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/15/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Delegate for the dashboard screen that gets notified about data updates.
protocol DashboardContentDelegate: class {

    /// Indicates whether or not `self` is loading.
    var isLoading: Bool { get set }

}
