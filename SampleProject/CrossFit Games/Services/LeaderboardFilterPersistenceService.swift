//
//  LeaderboardFilterPersistenceService.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Service for persisting leaderboard filter selections.
struct LeaderboardFilterPersistenceService {

    // MARK: - Public Properties
    
    /// Data store for saving leaderboard selections.
    let dataStore: LeaderboardDataStore

    // MARK: - Public Functions
    
    /// Persists the given selection, saving it under the given name.
    ///
    /// - Parameters:
    ///   - selection: Selection to save.
    ///   - name: Name for the filter selection.
    func persist(selectedControls: LeaderboardControls,
                 controls: [LeaderboardControls],
                 selection: [LeaderboardFilterSelection],
                 affiliate: String?,
                 withName name: String) {
        dataStore.leaderboardSelections[name] = CustomLeaderboard(controls: controls,
                                                                  filterSelection: selection,
                                                                  selectedControls: selectedControls,
                                                                  affiliate: affiliate)
    }

    /// Persists the given leaderboard.
    ///
    /// - Parameters:
    ///   - leaderboard: Leaderboard to persist as filter set.
    ///   - name: Unique name of the leaderboard for persistence.
    func persist(leaderboard: CustomLeaderboard, named name: String) {
        dataStore.leaderboardSelections[name] = leaderboard
    }

    /// Loads the selection with the given name (if it exists).
    ///
    /// - Parameter name: Name of the selection.
    /// - Returns: Filter selection or nil if the given name can't be found.
    func loadSelection(named name: String) -> CustomLeaderboard? {
        return dataStore.leaderboardSelections[name]
    }

    /// Deletes a leaderboard with the given name if it exists.
    ///
    /// - Parameter name: Name of the leaderboard to delete.
    func deleteLeaderboard(named name: String) {
        dataStore.leaderboardSelections[name] = nil
    }

}
