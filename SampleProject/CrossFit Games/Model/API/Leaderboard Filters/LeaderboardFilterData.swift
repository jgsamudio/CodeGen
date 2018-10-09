//
//  LeaderboardFilterData.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/5/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Common base structure of filters on the API.
protocol LeaderboardFilterData: Codable {

    /// Filter value used as filter parameter in requests.
    var value: String { get }

    /// Value that can be displayed to users, representing what this particular filter data means.
    var display: String { get }
    
}
