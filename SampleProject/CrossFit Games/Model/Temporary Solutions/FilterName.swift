//
//  FilterName.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/16/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Common filter names that are used directly to access leaderboards throughout the app.
enum FilterName: String {
    case fittestIn = "fittest"
    case fittestInDetail = "fittest1"
    case region
    case regionSearch = "region_search"
    case country
    case state
    case division
    case page
    case sort
    case competition
    case year
    case workoutType = "scaled"
    case occupation
}
