//
//  Competition.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/11/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Competition types represented via key from the API.
enum Competition: Int {
    case open = 1
    case regionals
    case games
    case onlineQualifier
    case teamSeries

    // MARK: - Public Properties
    
    /// String for representation of `self` in a search query (e.g.
    /// `https://games.crossfit.com//competitions/api/v1/competitions/open/2017?expand%5B%5D=controls` for
    /// Competition.open.searchQueryString
    var searchQueryString: String {
        switch self {
        case .open:
            return "open"
        case .regionals:
            return "regionals"
        case .games:
            return "games"
        case .onlineQualifier:
            return "onlinequalifiers"
        case .teamSeries:
            return "teamseries"
        }
    }
}
