//
//  GamesLeaderboardListTests.swift
//  CrossFit GamesTests
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

@testable import CrossFit_Games
import XCTest

class GamesLeaderboardListTests: XCTestCase {

    // MARK: - Public Functions
    
    func testParsingLeaderboards() {
        guard let filePath = Bundle(for: GamesLeaderboardListTests.self).url(forResource: "leaderboard_games", withExtension: "json"),
            let json = try? Data(contentsOf: filePath) else {
                XCTFail("Failed due to being unable to parse file from disk.")
                return
        }

    // MARK: - Public Properties
    
        let stringValue = String(data: json, encoding: .ascii)
        guard let data = stringValue?.data(using: .utf8) else {
            XCTFail("Whoops")
            return
        }

        let decoder = JSONDecoder()
        XCTAssertNoThrow(try decoder.decode(LeaderboardPageGamesRegionals.self, from: data))

        do {
            let leaderboardPage = try decoder.decode(LeaderboardPageGamesRegionals.self, from: data)

            leaderboardPage.items.forEach({ (item) in
                XCTAssertNotNil(item.user.profilePic)
                XCTAssertNotNil(item.user.region)
                XCTAssertNotNil(item.user.age)
                XCTAssertNotNil(item.user.divisionId)
            })

            XCTAssertEqual(leaderboardPage.items.count, 40)
        } catch {
            XCTFail("Failed with error: \(error)")
        }
    }

}
