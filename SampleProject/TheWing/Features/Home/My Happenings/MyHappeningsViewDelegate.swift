//
//  MyHappeningsViewDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol MyHappeningsViewDelegate: EventListViewDelegate {
    
    /// Reloads an event cell.
    ///
    /// - Parameter row: Row to reload.
    func reloadEventCell(row: Int)

    /// Sets the navigation bar title.
    ///
    /// - Parameter title: Title to set the navigation bar as.
    func setNavigationTitle(_ title: String)
    
    /// Should attempt to present push permission
    func attemptToPresentPushPermission()
    
    /// Set is loading
    ///
    /// - Parameter isLoading: is it loading?
    func set(isLoading: Bool)
}
