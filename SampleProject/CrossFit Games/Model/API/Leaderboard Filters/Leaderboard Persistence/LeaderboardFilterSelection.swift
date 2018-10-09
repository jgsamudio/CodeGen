//
//  LeaderboardFilterSelection.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/11/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Filter selection
enum LeaderboardFilterSelection: Codable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case type
        case filter
        case selection
        case nestedSelection
        case sort
        case region
        case country
        case state
    }

    private enum SelectionType: String {
        case `default`
        case multiselect
        case region
    }

    /// Selection for default `LeaderboardFilterData`
    case defaultSelection(filter: LeaderboardFilter,
        selection: LeaderboardFilterData)

    /// Selection for `MultiselectLeaderboardFilterData`
    case multiSelect(filter: LeaderboardFilter,
        selection: MultiselectLeaderboardFilterData,
        nestedSelection: MultiselectLeaderboardFilterData.Selection)

    case regionSelect(filter: LeaderboardFilter,
        selection: RegionSelectionFilterData,
        region: LeaderboardFilterData,
        nestedRegion: LeaderboardFilterData?)

    /// Filter of `self`.
    var filter: LeaderboardFilter {
        switch self {
        case .defaultSelection(filter: let filter, selection: _):
            return filter
        case .multiSelect(filter: let filter, selection: _, nestedSelection: _):
            return filter
        case .regionSelect(filter: let filter, selection: _, region: _, nestedRegion: _):
            return filter
        }
    }

    /// Selection of `self`.
    var selection: LeaderboardFilterData {
        switch self {
        case .defaultSelection(filter: _, selection: let selection):
            return selection
        case .multiSelect(filter: _, selection: let selection, nestedSelection: _):
            return selection
        case .regionSelect(filter: _, selection: let selection, region: _, nestedRegion: _):
            return selection
        }
    }

    /// Retrieves the selection options that are available for the given filter.
    ///
    /// - Parameter filter: Filter for which selection options should be retrieved.
    /// - Returns: Available selection options.
    static func availableSelection(for filter: LeaderboardFilter) -> [LeaderboardFilterSelection] {
        var result = [LeaderboardFilterSelection]()

        filter.data.forEach { (data) in
            switch data {
            case let val as MultiselectLeaderboardFilterData:
                val.selects.forEach({ (selection) in
                    result.append(LeaderboardFilterSelection.multiSelect(filter: filter,
                                                                         selection: val,
                                                                         nestedSelection: selection))
                })
            case let val as RegionSelectionFilterData:
                val.regions.forEach({ (filterData) in
                    if filterData as? RegionFilterData != nil {
                        result.append(LeaderboardFilterSelection.regionSelect(filter: filter,
                                                                              selection: val,
                                                                              region: filterData,
                                                                              nestedRegion: nil))
                    } else {
                        result.append(LeaderboardFilterSelection.defaultSelection(filter: filter,
                                                                                  selection: filterData))
                    }
                })
            default:
                result.append(LeaderboardFilterSelection.defaultSelection(filter: filter,
                                                                          selection: data))
            }
        }

        return result
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard let type = try SelectionType(rawValue: container.decode(String.self, forKey: .type)) else {
            throw EncodingError.invalidValue(CodingKeys.type, EncodingError.Context(codingPath: [CodingKeys.type], debugDescription: "Invalid type"))
        }

        let filter = try container.decode(LeaderboardFilter.self, forKey: .filter)
        let selection: LeaderboardFilterData = try (try? container.decode(MultiselectLeaderboardFilterData.self, forKey: .selection))
            ?? (try? container.decode(RegionSelectionFilterData.self, forKey: .selection))
            ?? (try? container.decode(SortableLeaderboardFilterData.self, forKey: .selection))
            ?? (try? container.decode(RegionFilterData.self, forKey: .selection))
            ?? container.decode(DefaultLeaderboardFilterData.self, forKey: .selection)

        switch type {
        case .default:
            self = .defaultSelection(filter: filter, selection: selection)
        case .multiselect:
            let nestedSelection = try container.decode(MultiselectLeaderboardFilterData.Selection.self, forKey: .nestedSelection)
            guard let multiSelect = selection as? MultiselectLeaderboardFilterData else {
                self = .defaultSelection(filter: filter, selection: selection)
                return
            }
            self = .multiSelect(filter: filter, selection: multiSelect, nestedSelection: nestedSelection)
        case .region:
            let region = try container.decode(RegionSelectionFilterData.self, forKey: .region)
            let country: LeaderboardFilterData = try (try? container.decode(RegionFilterData.self, forKey: .country))
                ?? container.decode(DefaultLeaderboardFilterData.self, forKey: .country)
            let state = try container.decodeIfPresent(RegionFilterData.self, forKey: .state)
            self = .regionSelect(filter: filter,
                                 selection: region,
                                 region: country,
                                 nestedRegion: state)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(filter, forKey: .filter)

        switch self {
        case .defaultSelection(filter: _, selection: let selection):
            try container.encode(SelectionType.default.rawValue, forKey: .type)
            switch selection {
            case let val as RegionSelectionFilterData:
                try container.encode(val, forKey: .selection)
            case let val as MultiselectLeaderboardFilterData:
                try container.encode(val, forKey: .selection)
            case let val as SortableLeaderboardFilterData:
                try container.encode(val, forKey: .selection)
            case let val as CodedLeaderboardFilterData:
                try container.encode(val, forKey: .selection)
            case let val as DefaultLeaderboardFilterData:
                try container.encode(val, forKey: .selection)
            default:
                break
            }
        case .regionSelect(filter: _, selection: let selection, region: let region, nestedRegion: let nestedRegion):
            try container.encodeIfPresent(selection, forKey: .region)
            switch region {
            case let val as RegionFilterData:
                try container.encodeIfPresent(val, forKey: .country)
            case let val as DefaultLeaderboardFilterData:
                try container.encodeIfPresent(val, forKey: .country)
            default:
                break
            }

            try container.encode(selection, forKey: .selection)

            if let multiselectLeaderboardFilterData = nestedRegion as? MultiselectLeaderboardFilterData {
                try container.encode(multiselectLeaderboardFilterData, forKey: .state)
            }
            if let sortableLeaderboardFilterData = nestedRegion as? SortableLeaderboardFilterData {
                try container.encode(sortableLeaderboardFilterData, forKey: .state)
            }
            if let regionFilterData = nestedRegion as? RegionFilterData {
                try container.encode(regionFilterData, forKey: .state)
            }
            if let codedLeaderboardFilterData = nestedRegion as? CodedLeaderboardFilterData {
                try container.encode(codedLeaderboardFilterData, forKey: .state)
            }
            if let defaultLeaderboardFilterData = nestedRegion as? DefaultLeaderboardFilterData {
                try container.encode(defaultLeaderboardFilterData, forKey: .state)
            }

            try container.encode(SelectionType.region.rawValue, forKey: .type)
        case .multiSelect(filter: _, selection: let selection, nestedSelection: let nestedSelection):
            try container.encode(nestedSelection, forKey: .nestedSelection)
            try container.encode(selection, forKey: .selection)
            try container.encode(SelectionType.multiselect.rawValue, forKey: .type)
        }
    }

}

// MARK: - CustomDebugStringConvertible
extension LeaderboardFilterSelection: CustomStringConvertible {

    var description: String {
        let name = filter.label
        let selection = self.selection.display
        let additionalInfo: String

        switch self {
        case .multiSelect(filter: _, selection: _, nestedSelection: let selection):
            additionalInfo = """
            Multiselect option: \(selection.display)
            """
        default:
            additionalInfo = ""
        }
        return """
        Filter: \(name ?? "")
        Selection: \(selection)
        \(additionalInfo)
        """
    }

}

func == (_ lhs: LeaderboardFilterSelection, _ rhs: LeaderboardFilterSelection) -> Bool {
    return lhs.description == rhs.description
}
