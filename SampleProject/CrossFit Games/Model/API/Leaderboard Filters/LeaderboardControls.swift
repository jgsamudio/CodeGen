//
//  LeaderboardControls.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/3/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Leaderboard controls as returned from [https://games.crossfit.com//competitions/api/v1/competitions/open/2017?expand%5B%5D=controls](
/// https://games.crossfit.com//competitions/api/v1/competitions/open/2017?expand%5B%5D=controls) for example.
struct LeaderboardControls: Codable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case id
        case identifier
        case name
        case year
        case active
        case type
        case controls
        case parentCompetitionId = "parent_competition_id"
        case startDate = "start_date"
        case config
    }

    /// ID of the competition
    let id: String

    /// Unique identifier of the competition.
    let identifier: String

    /// Name of the competition.
    let name: String

    /// Year of the competition.
    let year: String

    /// Indication of whether the competition is active or not.
    let active: String

    /// Type of the competition.
    let type: String

    /// ID of the parent competition
    let parentCompetitionId: String?

    /// Start date of the competition
    let startDate: Date?

    /// Config for the leaderboard controls.
    let config: LeaderboardControlsConfig?

    /// Filters provided as controls for the competition results when filtering the leaderboard.
    let controls: [LeaderboardFilter]

    /// Indicates whether `self` is an active competition.
    var isActive: Bool {
        return active == "1"
    }

    init(id: String,
         identifier: String,
         name: String,
         year: String,
         active: String,
         type: String,
         parentCompetitionId: String?,
         startDate: Date?,
         config: LeaderboardControlsConfig?,
         controls: [LeaderboardFilter]) {
        self.id = id
        self.identifier = identifier
        self.name = name
        self.year = year
        self.active = active
        self.type = type
        self.parentCompetitionId = parentCompetitionId
        self.controls = controls
        self.startDate = startDate
        self.config = config
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        identifier = try container.decode(String.self, forKey: .identifier)
        name = try container.decode(String.self, forKey: .name)
        year = try container.decode(String.self, forKey: .year)
        active = try container.decode(String.self, forKey: .active)
        type = try container.decode(String.self, forKey: .type)
        parentCompetitionId = try container.decodeIfPresent(String.self, forKey: .parentCompetitionId)
        startDate = try container.decodeIfPresentAllowDate(Date.self, forKey: .startDate)
        let config = try container.decodeIfPresent(LeaderboardControlsConfig.self, forKey: .config)

        let controls = try container.decode([LeaderboardFilter].self, forKey: .controls)

        var allControls = controls
        controls.forEach { (filter) in
            filter.data.flatMap({ (data) -> SortableLeaderboardFilterData? in
                return data as? SortableLeaderboardFilterData
            }).forEach({ (data) in
                for filter in data.controls where !allControls.contains(filter) {
                    allControls.append(filter)
                }
            })
        }

        let filteredControls = LeaderboardFilterPostProcessing(input: allControls).output.filter { (filter) -> Bool in
            config?.controls?.contains(filter.configName) ?? true
        }.sorted { (lhs, rhs) -> Bool in
            guard let lhsIndex = config?.controls?.index(of: lhs.configName),
                let rhsIndex = config?.controls?.index(of: rhs.configName) else {
                    return false
            }

            return lhsIndex < rhsIndex
        }

        self.controls = filteredControls
        self.config = config
    }

}

func == (_ lhs: LeaderboardControls, _ rhs: LeaderboardControls) -> Bool {
    return lhs.id == rhs.id
        && lhs.type == rhs.type
        && lhs.year == rhs.year
        && lhs.controls.sorted(by: { (lhs, rhs) -> Bool in
            lhs.configName.compare(rhs.configName) == .orderedAscending
        }).elementsEqual(rhs.controls.sorted(by: { (lhs, rhs) -> Bool in
            lhs.configName.compare(rhs.configName) == .orderedAscending
        }))
}
