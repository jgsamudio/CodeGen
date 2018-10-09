//
//  WorkoutType.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/24/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Competition phase
enum CompetitionPhase: String {

    case open = "Open"
    case theGames = "The Games"
    case onlineQualifiers = "Online Qualifiers"
    case regionals = "Regionals"
    case teamSeries = "Team Series"

//    func localize(localization: WorkoutsLocalization) -> String {
//        switch self {
//        case .open:
//            return localization.open
//        case .theGames:
//            return localization.theGames
//        case .onlineQualifiers:
//            return localization.onlineQualifiers
//        case .regionals:
//            return localization.regionals
//        case .teamSeries:
//            return localization.teamSeries
//        }
//    }
//
//    static func byString(string: String) -> CompetitionPhase? {
//        switch string {
//        case CompetitionPhase.open.rawValue:
//            return .open
//        case CompetitionPhase.theGames.rawValue:
//            return .theGames
//        case CompetitionPhase.onlineQualifiers.rawValue:
//            return .onlineQualifiers
//        case CompetitionPhase.regionals.rawValue:
//            return .regionals
//        case CompetitionPhase.teamSeries.rawValue:
//            return .teamSeries
//        default:
//            return nil
//        }
//    }
}
