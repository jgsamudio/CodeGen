//
//  FilterSearchDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol FilterSearchDelegate: class {

    /// Called when the filter button is selected.
    func filterButtonSelected()

    /// Called when the constraints need animated.
    func animateConstraints()
    
    /// Called when search action is taken by user.
    ///
    /// - Parameter searchText: Search text entered.
    func displaySearchResult(with searchText: String?)
    
    /// Called when user selects cancel.
    func cancelSearch()
    
}
