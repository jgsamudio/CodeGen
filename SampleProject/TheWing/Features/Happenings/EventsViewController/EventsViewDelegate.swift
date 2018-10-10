//
//  EventsViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 2/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EventsViewDelegate: EventListViewDelegate {
        
    /// Resets view.
    func reset()

    /// Sets the count of filter items in filter button.
    ///
    /// - Parameter count: Count of applied filters.
    func setFilterCount(_ count: Int)
    
    /// Reloads the filtes at the given location.
    ///
    /// - Parameters:
    ///   - section: Section to reload.
    ///   - row: Row to reload.
    func reloadEventCell(at section: Int, row: Int)

    /// Displays or hides the no results view.
    ///
    /// - Parameter show: Determines if the view should show or hide.
    func displayNoResultsView(show: Bool)

    /// Should attempt to present push permission
    func attemptToPresentPushPermission()

}
