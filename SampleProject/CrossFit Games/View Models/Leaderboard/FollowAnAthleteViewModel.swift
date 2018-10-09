//
//  FollowAnAthleteViewModel.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// View model which contains required properties
/// for the following an athlete view controller
struct FollowAnAthleteViewModel {

    // MARK: - Public Properties
    
    /// Currently following athlete
    let followingAthlete: LeaderboardAthleteResultCellViewModel

    /// The athlete who was follown before changing to the latest
    let previousAthlete: LeaderboardAthleteResultCellViewModel?

}
