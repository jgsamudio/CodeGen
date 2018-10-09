//
//  OnlineQualifiersLeaderboardListTests.swift
//  CrossFit GamesTests
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

@testable import CrossFit_Games
import XCTest

class OnlineQualifiersLeaderboardListTests: XCTestCase {

    func testParsingLeaderboards() {
        guard let filePath = Bundle(for: OnlineQualifiersLeaderboardListTests.self)
            .url(forResource: "leaderboard_onlinequalifiers", withExtension: "json"),
            let json = try? Data(contentsOf: filePath) else {
                XCTFail("Failed due to being unable to parse file from disk.")
                return
        }

        let stringValue = String(data: json, encoding: .ascii)
        guard let data = stringValue?.data(using: .utf8) else {
            XCTFail("Whoops")
            return
        }

        let decoder = JSONDecoder()
        XCTAssertNoThrow(try decoder.decode(LeaderboardPageOpenOnline.self, from: data))

        do {
            let leaderboardPage = try decoder.decode(LeaderboardPageOpenOnline.self, from: data)

            leaderboardPage.items.forEach({ (item) in
                XCTAssertNotNil(item.user.profilePic)
                XCTAssertNotNil(item.user.region)
                XCTAssertNotNil(item.user.age)
                XCTAssertNotNil(item.user.divisionId)
            })

            XCTAssertEqual(leaderboardPage.items.count, 50)
        } catch {
            XCTFail("Failed with error: \(error)")
        }
    }

}
