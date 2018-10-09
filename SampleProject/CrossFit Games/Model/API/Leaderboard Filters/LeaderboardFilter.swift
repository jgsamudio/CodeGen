//
//  LeaderboardFilter.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/2/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// A filter for leaderboards.
struct LeaderboardFilter: Codable {

    /// Config name for the year selection.
    static let yearConfigName = "year"

    /// Config name for the competition selection.
    static let competitionConfigName = "competition"

    /// Config name for the sort selection.
    static let sortConfigName = FilterName.sort.rawValue

    private enum CodingKeys: String, CodingKey {
        case configName = "config_name"
        case name
        case label
        case type
        case data
    }

    /// Config name. This represents the key of the query item for a specific filter.
    let configName: String

    /// Name of the filter.
    let name: String

    /// Value that can be displayed to tell the user what filter this is.
    let label: String?

    /// Filter type.
    let type: String

    /// Data that contains filter selection options.
    let data: [LeaderboardFilterData]

    init(configName: String, name: String, label: String?, type: String, data: [LeaderboardFilterData]) {
        self.configName = configName
        self.name = name
        self.label = label
        self.type = type
        self.data = data
    }

    /// Indicates whether `self` is a year filter.
    var isYearFilter: Bool {
        return configName == LeaderboardFilter.yearConfigName
    }

    /// Indicates whether `self` is a competition filter.
    var isCompetitionFilter: Bool {
        return configName == LeaderboardFilter.competitionConfigName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        configName = try container.decode(String.self, forKey: .configName)
        name = try container.decode(String.self, forKey: .name)
        label = try container.decodeIfPresent(String.self, forKey: .label)
        type = try container.decode(String.self, forKey: .type)

        var data = [LeaderboardFilterData]()
        guard var dataContainer = try? container.nestedUnkeyedContainer(forKey: .data) else {
            self.data = []
            return
        }

        while !dataContainer.isAtEnd {
            if let multiSelect = try? dataContainer.decode(MultiselectLeaderboardFilterData.self) {
                data.append(multiSelect)
            } else if let sortable = try? dataContainer.decode(SortableLeaderboardFilterData.self) {
                data.append(sortable)
            } else if let regions = try? dataContainer.decode(RegionFilterData.self) {
                data.append(regions)
            } else if let coded = try? dataContainer.decode(CodedLeaderboardFilterData.self) {
                data.append(coded)
            } else if let defaultData = try? dataContainer.decode(DefaultLeaderboardFilterData.self) {
                data.append(defaultData)
            } else {
                _ = try dataContainer.decode(NilDecodable.self)
            }
        }
        self.data = data
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(configName, forKey: .configName)
        try container.encode(name, forKey: .name)
        try container.encode(label, forKey: .label)
        try container.encode(type, forKey: .type)

        var dataContainer = container.nestedUnkeyedContainer(forKey: .data)

        try data.forEach({ filterData in
            if let multiselectLeaderboardFilterData = filterData as? MultiselectLeaderboardFilterData {
                try dataContainer.encode(multiselectLeaderboardFilterData)
            }
            if let sortableLeaderboardFilterData = filterData as? SortableLeaderboardFilterData {
                try dataContainer.encode(sortableLeaderboardFilterData)
            }
            if let regionFilterData = filterData as? RegionFilterData {
                try dataContainer.encode(regionFilterData)
            }
            if let codedLeaderboardFilterData = filterData as? CodedLeaderboardFilterData {
                try dataContainer.encode(codedLeaderboardFilterData)
            }
            if let defaultLeaderboardFilterData = filterData as? DefaultLeaderboardFilterData {
                try dataContainer.encode(defaultLeaderboardFilterData)
            }
        })
    }

}

// MARK: - Hashable
extension LeaderboardFilter: Hashable {

    var hashValue: Int {
        return name.hash
    }

}

func == (_ lhs: LeaderboardFilter, _ rhs: LeaderboardFilter) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
