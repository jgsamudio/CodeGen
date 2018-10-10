//
//  LeaderboardFilterTests.swift
//  CrossFit GamesTests
//
//  Created by Daniel Vancura on 10/3/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

@testable import CrossFit_Games
import XCTest

class LeaderboardFilterTests: XCTestCase {

    // MARK: - Public Functions
    
    func testParsingFilters() {
        guard let filePath = Bundle(for: LeaderboardFilterTests.self).url(forResource: "LeaderboardFilterResponse", withExtension: "json"),
            let json = try? Data(contentsOf: filePath) else {
                XCTFail("Failed due to being unable to parse file from disk.")
                return
        }

    // MARK: - Public Properties
    
        let decoder = JSONDecoder()
        XCTAssertNoThrow(try decoder.decode(LeaderboardControls.self, from: json))

        do {
            let leaderboardControls = try decoder.decode(LeaderboardControls.self, from: json)

            /// Test competition filters
            guard let competitionFilter = leaderboardControls.controls.first(where: { (filter) -> Bool in
                filter.name == LeaderboardFilter.competitionConfigName
                }) else {
                    XCTFail("Missing competition filter")
                    return
            }
            competitionFilter.data.forEach({ (filterOption) in
                XCTAssertTrue(type(of: filterOption) == DefaultLeaderboardFilterData.self)
            })
            XCTAssertEqual(competitionFilter.data.count, 6)

            /// Test year filters
            guard let yearFilter = leaderboardControls.controls.first(where: { (filter) -> Bool in
                filter.name == LeaderboardFilter.yearConfigName
            }) else {
                XCTFail("Missing year filter")
                return
            }
            yearFilter.data.forEach({ (filterOption) in
                XCTAssertTrue(type(of: filterOption) == DefaultLeaderboardFilterData.self)
            })
            XCTAssertEqual(yearFilter.data.count, 7)

            /// Scaled filters
            guard let scaledFilter = leaderboardControls.controls.first(where: { (filter) -> Bool in
                filter.name == "scaled"
            }) else {
                XCTFail("Missing scaled filter")
                return
            }
            scaledFilter.data.forEach({ (filterOption) in
                XCTAssertTrue(type(of: filterOption) == DefaultLeaderboardFilterData.self)
            })
            XCTAssertEqual(scaledFilter.data.count, 2)

            /// Fittest filters
            guard let fittestFilter = leaderboardControls.controls.first(where: { (filter) -> Bool in
                filter.name == "fittest"
            }) else {
                XCTFail("Missing fittest filter")
                return
            }
            fittestFilter.data.forEach({ (filterOption) in
                XCTAssertTrue(type(of: filterOption) == MultiselectLeaderboardFilterData.self)
            })
            XCTAssertEqual(fittestFilter.data.count, 5)

            /// Occupation filters
            guard let occupationFilter = leaderboardControls.controls.first(where: { (filter) -> Bool in
                filter.name == "occupation"
            }) else {
                XCTFail("Missing occupation filter")
                return
            }
            occupationFilter.data.forEach({ (filterOption) in
                XCTAssertTrue(type(of: filterOption) == CodedLeaderboardFilterData.self)
            })
            XCTAssertEqual(occupationFilter.data.count, 10)

            /// Division filters
            guard let divisionFilter = leaderboardControls.controls.first(where: { (filter) -> Bool in
                filter.name == "division"
            }) else {
                XCTFail("Missing division filter")
                return
            }
            divisionFilter.data.forEach({ (filterOption) in
                XCTAssertTrue(type(of: filterOption) == SortableLeaderboardFilterData.self)
            })
            XCTAssertEqual(divisionFilter.data.count, 19)
        } catch {
            XCTFail("Failed with error: \(error)")
        }
    }

}
