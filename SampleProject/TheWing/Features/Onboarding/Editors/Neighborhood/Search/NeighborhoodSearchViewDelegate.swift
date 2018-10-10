//
//  NeighbordhoodSearchViewDelegate.swift
//  TheWing
//
//  Created by Paul Jones on 8/3/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol NeighborhoodSearchViewDelegate: class {
    
    /// Informs the view controller that the view model has new data to be presented.
    func refresh()
    
}
