//
//  NeighborhoodSearchViewControllerDelegate.swift
//  TheWing
//
//  Created by Paul Jones on 8/3/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol NeighborhoodSearchViewControllerDelegate: class {
    
    /// Tells you when the user has selected a neighborhood
    ///
    /// - Parameters:
    ///   - viewController: Which view controller did this?
    ///   - neighborhood: What's the neigborhood the user selected?
    func neighborhoodSearchViewController(_ viewController: NeighborhoodSearchViewController,
                                          didSelectNeighborhood neighborhood: String)
    
    /// Tells you that cancel was pressed, dismiss this view controller.
    ///
    /// - Parameter viewController: The VC which had cancel tapped.
    func neighborhoodSearchViewControllerCancelTouchUpInside(_ viewController: NeighborhoodSearchViewController)
    
}
