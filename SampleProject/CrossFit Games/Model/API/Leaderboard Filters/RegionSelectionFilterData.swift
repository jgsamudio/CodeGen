//
//  RegionSelectionFilterData.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct RegionSelectionFilterData: LeaderboardFilterData {

    private enum CodingKeys: String, CodingKey {
        case value
        case display
        case regions
    }

    let value: String

    let display: String

    let regions: [LeaderboardFilterData]

    init(value: String, display: String, regions: [LeaderboardFilterData]) {
        self.value = value
        self.display = display
        self.regions = regions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        value = try container.decode(String.self, forKey: .value)
        display = try container.decode(String.self, forKey: .display)

        var dataContainer = try container.nestedUnkeyedContainer(forKey: .regions)
        var data = [LeaderboardFilterData]()
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

        regions = data
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(value, forKey: .value)
        try container.encode(display, forKey: .display)
        
        var dataContainer = container.nestedUnkeyedContainer(forKey: .regions)
        try regions.forEach({ filterData in
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
