//
//  FilterSearchTabHeaderViewDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

protocol FilterSearchTabHeaderViewDelegate: TabItemHeaderViewDelegate {

    /// Called when the filter button is selected.
    func filterButtonSelected()

    /// Called when the constraints need to be animated.
    func animateHeaderConstraints(with offset: CGFloat)
    
    /// Called when search action is taken by the user.
    ///
    /// - Parameter searchText: Search text entered.
    func displaySearchResult(with searchText: String?)
    
    /// Called when user selects cancel.
    func cancelSearch()
    
}
