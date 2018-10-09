//
//  UserDefaultsKey.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// An enum to represent the key values to be
/// persisted in user defaults
enum UserDefaultsKey: String {
    case currentAuthEnvironment
    case currentGeneralEnvironment
    case userAccessToken
    case accessTokenExpirationDate
    case customLeaderboards
    case workoutDivisionSelection
    case workoutTypeSelection
    case datePickerSelection
    case appOpenCount
    case firstRunToken
    case forceAppUpdate
    case killSwitchStatus
    case useDummyForKillSwitch
    case followingAthleteViewModel
    case followingAthleteCustomLeaderboard
    case coachMarkTapped
    case dashboardRefreshTimestamp
}
