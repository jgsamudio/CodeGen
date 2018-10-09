//
//  LeaderboardFilterSelectionServiceTests.swift
//  CrossFit GamesTests
//
//  Created by Daniel Vancura on 10/24/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

@testable import CrossFit_Games
import XCTest

class LeaderboardFilterSelectionServiceTests: XCTestCase {

    var filterSelectionService: LeaderboardFilterSelectionService!

    override func setUp() {
        super.setUp()

        filterSelectionService = LeaderboardFilterSelectionService(controls: loadControls(),
                                                                   competitionInfoSerivce: ServiceFactory.shared.createCompetitionInfoService())
    }

    override func tearDown() {
        super.tearDown()

        filterSelectionService = nil
    }

    func testLeaderboardFilterCount() {
        XCTAssertEqual(filterSelectionService.availableCompetitions.count, 1)
        XCTAssertEqual(filterSelectionService.availableYears(for: "open").count, 1)
        XCTAssertEqual(filterSelectionService.numberOfAvailableFilters, 5)

        // Index 3: Division filter. (19 different divisions)
        XCTAssertEqual(filterSelectionService.numberOfOptions(forFilterAt: IndexPath(indexes: [0])), 19)
    }

    func testLeaderboardFilterCountRemovingSort() {
        let competitionInfoService = ServiceFactory.shared.createCompetitionInfoService()
        guard let filterSelectionService = LeaderboardFilterSelectionService(controls: loadControlsWithoutSort(),
                                                                             competitionInfoSerivce: competitionInfoService) else {
                                                                                XCTFail("Failed to load filters")
                                                                                return
        }
        XCTAssertEqual(filterSelectionService.availableCompetitions.count, 1)
        XCTAssertEqual(filterSelectionService.availableYears(for: "open").count, 1)
        XCTAssertEqual(filterSelectionService.numberOfAvailableFilters, 4)
        XCTAssertFalse((0..<filterSelectionService.numberOfAvailableFilters)
            .map(filterSelectionService.filter)
            .map {$0.configName}.contains("sort"))
        XCTAssertTrue((0..<filterSelectionService.numberOfAvailableFilters)
            .map(filterSelectionService.filter)
            .map {$0.configName}.contains("division"))
        XCTAssertTrue((0..<filterSelectionService.numberOfAvailableFilters)
            .map(filterSelectionService.filter)
            .map {$0.configName}.contains("scaled"))

        // Index 3: Division filter. (19 different divisions)
        XCTAssertEqual(filterSelectionService.numberOfOptions(forFilterAt: IndexPath(indexes: [0])), 19)
    }

    func testLeaderboardFilterNames() {
        XCTAssertEqual(filterSelectionService.displayNameForFilter(at: IndexPath(indexes: [0, 0])), "Individual Women")
        XCTAssertEqual(filterSelectionService.displayNameForFilter(at: IndexPath(indexes: [2, 0])), "Overall")
    }

    private func loadControls() -> [LeaderboardControls] {
        guard let filePath = Bundle(for: LeaderboardFilterTests.self).url(forResource: "LeaderboardFilterResponse", withExtension: "json"),
            let json = try? Data(contentsOf: filePath) else {
                XCTFail("Failed due to being unable to parse file from disk.")
                return []
        }

        let decoder = JSONDecoder()
        do {
            return try [decoder.decode(LeaderboardControls.self, from: json)]
        } catch {
            XCTFail("Failed to load controls")
            return []
        }
    }

    private func loadControlsWithoutSort() -> [LeaderboardControls] {
        guard let filePath = Bundle(for: LeaderboardFilterTests.self).url(forResource: "LeaderboardFilterResponseWithoutSort", withExtension: "json"),
            let json = try? Data(contentsOf: filePath) else {
                XCTFail("Failed due to being unable to parse file from disk.")
                return []
        }

        let decoder = JSONDecoder()
        do {
            return try [decoder.decode(LeaderboardControls.self, from: json)]
        } catch {
            XCTFail("Failed to load controls")
            return []
        }
    }

}
