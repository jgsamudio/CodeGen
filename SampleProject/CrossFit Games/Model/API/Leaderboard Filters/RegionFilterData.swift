//
//  RegionFilterData.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct RegionFilterData: LeaderboardFilterData {

    private enum CodingKeys: String, CodingKey {
        case display
        case value = "code"
        case states
        case name
    }

    // MARK: - Public Properties
    
    let display: String

    let value: String

    let name: String

    let states: [RegionFilterData]?

    // MARK: - Initialization
    
    init(display: String, value: String, name: String, states: [RegionFilterData]?) {
        self.display = display
        self.value = value
        self.name = name
        self.states = states
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        display = try container.decode(String.self, forKey: .display)
        value = try container.decode(String.self, forKey: .value)
        name = try container.decode(String.self, forKey: .name)

        if var nestedContainer = try? container.nestedUnkeyedContainer(forKey: .states) {
            var result = [RegionFilterData]()
            while !nestedContainer.isAtEnd {
                if let stateValue = try? nestedContainer.decode(RegionFilterData.self) {
                    result.append(stateValue)
                } else {
                    _ = try nestedContainer.decode(NilDecodable.self)
                }
            }
            states = result
        } else {
            states = nil
        }
    }

}
