//
//  DashboardStatsLocalization.swift
//  CrossFit Games
//
//  Created by Malinka S on 11/15/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Localization for Dashboard Stats
struct DashboardStatsLocalization {

    let overallRank = "DASHBOARD_STATS_OVERALL_RANK".localized

    let percentile = "DASHBOARD_STATS_PERCENTILE".localized

    let rank = "DASHBOARD_STATS_RANK".localized

    let checkBackLater = "DASHBOARD_STATS_CHECK_BACK_LATER".localized

    func scoresAppearWhenOpenStarts(_ openYear: String) -> String {
        return String.localizedStringWithFormat("DASHBOARD_STATS_SCORE_APPEAR_WHEN_OPEN".localized, openYear)
    }

}
