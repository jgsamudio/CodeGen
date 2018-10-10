//
//  TopMatchesViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 8/24/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol TopMatchesViewDelegate: ErrorDelegate {
    
    /// Sets the navigation bar title.
    ///
    /// - Parameter title: Title to set the navigation bar as.
    func setNavigationTitle(_ title: String)
    
    /// Called when the loading state changes.
    ///
    /// - Parameter loading: Determines if there is a network call loading.
    func isLoading(_ loading: Bool)

    /// Refresh the view.
    func refresh()
    
}
