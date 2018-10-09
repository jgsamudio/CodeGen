//
//  CompetitionInfoService.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Service for getting general information about competitions.
struct CompetitionInfoService {

    // MARK: - Private Properties
    
    private let dataStore: CompetitionInfoDataStore

    // MARK: - Initialization
    
    init(dataStore: CompetitionInfoDataStore) {
        self.dataStore = dataStore
    }

    // MARK: - Public Properties
    
    var allCompetitions: [(String, String)] {
        return dataStore.activeStates.map({ (pair) -> (String, String) in
            return (pair.key.type, pair.key.year)
        })
    }

    // MARK: - Public Functions
    
    /// Returns the start date for the given competition type in the given year.
    ///
    /// - Parameters:
    ///   - competitionType: Competition type.
    ///   - year: Competition year.
    /// - Returns: Start date of the requested competition.
    func startDate(for competitionType: String, in year: String) -> Date? {
        return dataStore.startDates[CompetitionInfoDataStore.Key(type: competitionType, year: year)]
    }

    /// Indicates whether the registration period of the given competition is active.
    ///
    /// - Parameters:
    ///   - competitionType: Competition type.
    ///   - year: Competition year.
    /// - Returns: True if the competition registration period is active.
    func isRegistrationOpen(for competitionType: String, in year: String) -> Bool {
        let key = CompetitionInfoDataStore.Key(type: competitionType, year: year)
        if let startDate = dataStore.registrationStartDates[key], let endDate = dataStore.registrationEndDates[key] {
            return startDate < Date() && Date() < endDate
        } else {
            return false
        }
    }

    /// Current active competitions (name & year pairs)
    var activeCompetitions: [(String, String)] {
        return dataStore.activeStates.filter({ (pair) -> Bool in
            pair.value
        }).map({ (pair) -> (String, String) in
            return (pair.key.type, pair.key.year)
        })
    }

    /// Indicates whether the user (whose personalized leaderboard is saved in the competition info data store)
    /// is registered in the active open competition.
    var isRegisteredForActiveOpen: Bool {
        guard let mostRecentOpenYear = dataStore.personalizedLeaderboard?.mostRecentOpenCompetition?.year else {
            return false
        }

        let key = CompetitionInfoDataStore.Key(type: Competition.open.searchQueryString,
                                               year: mostRecentOpenYear)
        return dataStore.activeStates[key] ?? false
    }

    /// Indicates whether the user can register for the current open and is not registered yet.
    var canRegisterForActiveOpen: Bool {
        // Find the key (competition type & year) for the active Open competition.
        guard let key = dataStore.activeStates
            .first(where: { $0.value && $0.key.type == Competition.open.searchQueryString })
            .map({ $0.key }) else {
                return false
        }

        return !isRegisteredForActiveOpen && isRegistrationOpen(for: key.type, in: key.year)
    }

    /// Updates `self` with the information given in the provided personalized leaderboard.
    ///
    /// - Parameter personalizedLeaderboard: Personalized leaderboard for an athlete.
    func update(using personalizedLeaderboard: PersonalizedLeaderboard) {
        dataStore.personalizedLeaderboard = personalizedLeaderboard
    }

    /// Updates `self` with the information given in the provided leaderboard controls for different years.
    ///
    /// - Parameter controls: Controls.
    func update(using controls: [LeaderboardControls]) {
        controls.forEach({ (controls) in
            let type = controls.type
            let year = controls.year

            let key = CompetitionInfoDataStore.Key(type: type, year: year)

            if let startDate = controls.startDate {
                dataStore.startDates[key] = startDate
            }
            if let registrationStart = controls.config?.registration?.startDate {
                dataStore.registrationStartDates[key] = registrationStart
            }
            if let registrationEnd = controls.config?.registration?.endDate {
                dataStore.registrationEndDates[key] = registrationEnd
            }
            dataStore.activeStates[key] = controls.isActive
        })
    }

}
