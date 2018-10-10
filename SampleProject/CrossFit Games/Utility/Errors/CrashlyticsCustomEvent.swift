//
//  CrashlyticsCustomEvent.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 2/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Events to log via Crahlytics in case unexpected behavior occurs.
enum CrashlyticsCustomEvent: Int {

    /// User got an invalid personalized leaderboard.
    case gotInvalidPersonalizedLeaderboard

    /// User got redirected to the login page when trying to submit a score.
    case submitScoreRedirectToLogin

    /// Finding the user on the leaderboard API when showing the dashboard stats failed.
    case didNotFindUserForDashboardStats

    // MARK: - Public Properties
    
    /// Error to send for crashlytics.
    var error: NSError {
        return NSError(domain: "com.crossfit.games.error.".appending(String(describing: self)),
                       code: rawValue,
                       userInfo: nil)
    }

}
