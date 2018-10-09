//
//  LeaderboardURLTests.swift
//  CrossFit GamesTests
//
//  Created by Daniel Vancura on 10/18/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

@testable import CrossFit_Games
import XCTest

class LeaderboardURLTests: XCTestCase {

    // MARK: - Public Functions
    
    func testCreatingLeaderboardURL() {
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

            guard let yearFilter = leaderboardControls.controls.first(where: { (filter) -> Bool in
                filter.configName == LeaderboardFilter.yearConfigName
            }) else {
                XCTFail("Missing filter")
                return
            }

            guard let competitionFilter = leaderboardControls.controls.first(where: { (filter) -> Bool in
                filter.configName == LeaderboardFilter.competitionConfigName
            }) else {
                XCTFail("Missing filter")
                return
            }

            guard let scaledFilter = leaderboardControls.controls.first(where: { (filter) -> Bool in
                filter.configName == "scaled"
            }) else {
                XCTFail("Missing filter")
                return
            }

            guard let fittestFilter = leaderboardControls.controls.first(where: { (filter) -> Bool in
                filter.configName == "fittest"
            }) else {
                XCTFail("Missing filter")
                return
            }

            guard let occupationFilter = leaderboardControls.controls.first(where: { (filter) -> Bool in
                filter.configName == "occupation"
            }) else {
                XCTFail("Missing filter")
                return
            }

            guard let divisionFilter = leaderboardControls.controls.first(where: { (filter) -> Bool in
                filter.configName == "division"
            }) else {
                XCTFail("Missing filter")
                return
            }

            guard let open = competitionFilter.data.first(where: { (data) -> Bool in
                data.value == "1"
            }) else {
                XCTFail("Missing data")
                return
            }

            guard let year2017 = yearFilter.data.first(where: { (data) -> Bool in
                data.value == "2017"
            }) else {
                XCTFail("Missing data")
                return
            }

            guard let scaled = scaledFilter.data.first(where: { (data) -> Bool in
                data.value == "1"
            }) else {
                XCTFail("Missing data")
                return
            }

            guard let country = fittestFilter.data.first(where: { (data) -> Bool in
                data.value == "2"
            }) as? MultiselectLeaderboardFilterData, let cameroon = country.selects.first(where: { (select) -> Bool in
                select.value == "CM"
            }) else {
                XCTFail("Missing data")
                return
            }

            guard let medicalDoctor = occupationFilter.data.first(where: { (data) -> Bool in
                data.value == "6"
            }) else {
                XCTFail("Missing data")
                return
            }

            guard let teamDivision = divisionFilter.data.first(where: { (data) -> Bool in
                data.value == "11"
            }) as? SortableLeaderboardFilterData, let sortBy17_3 = teamDivision.controls.first(where: { (control) -> Bool in
                control.configName == "sort"
            }), let sortData = sortBy17_3.data.first(where: { (item) -> Bool in
                item.value == "3"
            }) else {
                XCTFail("Missing data")
                return
            }

            let leaderboard = CustomLeaderboard(controls: [leaderboardControls],
                                                filterSelection: [.defaultSelection(filter: yearFilter, selection: year2017),
                                                                  .defaultSelection(filter: competitionFilter, selection: open),
                                                                  .defaultSelection(filter: scaledFilter, selection: scaled),
                                                                  .multiSelect(filter: fittestFilter,
                                                                               selection: country,
                                                                               nestedSelection: cameroon),
                                                                  .defaultSelection(filter: occupationFilter, selection: medicalDoctor),
                                                                  .defaultSelection(filter: divisionFilter, selection: teamDivision),
                                                                  .defaultSelection(filter: sortBy17_3, selection: sortData)],
                                                selectedControls: leaderboardControls,
                                                affiliate: nil)

            let request = LeaderboardRequest(customLeaderboard: leaderboard)

            try XCTAssertEqual(request.rawValue.url.asURL().absoluteString,
                               "https://games.crossfit.com/competitions/api/v1/competitions/open/2017/leaderboards")
            XCTAssertTrue(request.rawValue.body?.contains(where: { (item) -> Bool in
                item.key == "scaled" && item.value as? String == "1"
            }) ?? false)
            XCTAssertTrue(request.rawValue.body?.contains(where: { (item) -> Bool in
                item.key == "fittest" && item.value as? String == "2"
            }) ?? false)
            XCTAssertTrue(request.rawValue.body?.contains(where: { (item) -> Bool in
                item.key == "fittest1" && item.value as? String == "CM"
            }) ?? false)
            XCTAssertTrue(request.rawValue.body?.contains(where: { (item) -> Bool in
                item.key == "occupation" && item.value as? String == "6"
            }) ?? false)
            XCTAssertTrue(request.rawValue.body?.contains(where: { (item) -> Bool in
                item.key == "division" && item.value as? String == "11"
            }) ?? false)
            XCTAssertTrue(request.rawValue.body?.contains(where: { (item) -> Bool in
                item.key == "sort" && item.value as? String == "3"
            }) ?? false)
            XCTAssertTrue(request.rawValue.body?.contains(where: { (item) -> Bool in
                item.key == "page" && item.value as? String == "1"
            }) ?? false)
            XCTAssertEqual(request.rawValue.body?.count, 7)
        } catch {
            XCTFail("Failed with error: \(error)")
        }
    }

}
