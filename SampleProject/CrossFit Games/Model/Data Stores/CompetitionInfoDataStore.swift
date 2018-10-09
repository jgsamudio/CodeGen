//
//  CompetitionInfoDataStore.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class CompetitionInfoDataStore {

    struct Key: Hashable {
        let type: String
        let year: String

        init(type: String, year: String) {
            self.type = type
            self.year = year
        }

        var hashValue: Int {
            return type.appending(year).hashValue
        }
    }

    /// Competition start dates.
    var startDates: [Key: Date] = [:]

    /// Competition start dates for active registration period.
    var registrationStartDates: [Key: Date] = [:]

    /// Competition end dates for active registration period.
    var registrationEndDates: [Key: Date] = [:]

    /// The user's personalized leaderboard.
    var personalizedLeaderboard: PersonalizedLeaderboard?

    /// Indications of which competitions are active.
    var activeStates: [Key: Bool] = [:]

}

func == (_ lhs: CompetitionInfoDataStore.Key, _ rhs: CompetitionInfoDataStore.Key) -> Bool {
    return lhs.type == rhs.type && lhs.year == rhs.year
}
