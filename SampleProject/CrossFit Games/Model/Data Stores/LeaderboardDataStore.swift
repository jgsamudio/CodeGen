//
//  LeaderboardDataStore.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/9/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Data store for leaderboard information.
final class LeaderboardDataStore {

    /// Selections made on leaderboards
    var leaderboardSelections: [String: CustomLeaderboard] {
        get {
            guard let data = UserDefaultsManager.shared.getData(byKey: UserDefaultsKey.customLeaderboards) else {
                return [:]
            }

            do {
                let decoder = PropertyListDecoder()
                return try decoder.decode([String: CustomLeaderboard].self, from: data)
            } catch {
                return [:]
            }
        }
        set {
            do {
                let encoder = PropertyListEncoder()
                let data = try encoder.encode(newValue)
                UserDefaultsManager.shared.setValue(withKey: UserDefaultsKey.customLeaderboards, value: data)
            } catch {
                return
            }
        }
    }

    private func leaderboardList(withPages pages: [LeaderboardPage]) -> [LeaderboardListItem?] {
        guard let firstItem = pages.first else {
            return []
        }

        let athleteCount = firstItem.totalPageCount * firstItem.items.count
        var result = [LeaderboardListItem?](repeating: nil, count: athleteCount)
        pages.forEach { (page) in
            result = insert(leaderboardPage: page, in: result)
        }

        return result
    }

    private func insert(leaderboardPage: LeaderboardPage,
                        in list: [LeaderboardListItem?]) -> [LeaderboardListItem?] {
        let pageSize = leaderboardPage.items.count
        let pageIndex = leaderboardPage.pageIndex

        var result = list
        for item in leaderboardPage.items.enumerated() {
            result[(pageIndex - 1) * pageSize + item.offset] = item.element
        }

        return result
    }

}
