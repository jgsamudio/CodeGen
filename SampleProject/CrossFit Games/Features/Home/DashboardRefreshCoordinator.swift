//
//  DashboardRefreshCoordinator.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 2/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Helper structure for managing dashboard refresh.
final class DashboardRefreshCoordinator {

    // MARK: - Private Properties
    
    private static let refreshInterval = 600.0

    // MARK: - Public Properties
    
    /// Last refresh date of the dashboard.
    var lastRefresh: Date? {
        get {
            return UserDefaultsManager.shared.getValue(byKey: .dashboardRefreshTimestamp) as? Date
        }
        set {
            UserDefaultsManager.shared.setValue(withKey: .dashboardRefreshTimestamp, value: newValue)
        }
    }

    /// Indicates whether the dashboard should refresh.
    var shouldRefresh: Bool {
        guard let lastRefresh = lastRefresh else {
            return true
        }

        return DatePicker.shared.date.timeIntervalSince(lastRefresh) > DashboardRefreshCoordinator.refreshInterval
    }

}
