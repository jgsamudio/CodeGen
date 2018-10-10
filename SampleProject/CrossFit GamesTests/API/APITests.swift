//
//  APITests.swift
//  CrossFit GamesTests
//
//  Created by Malinka S on 1/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

@testable import CrossFit_Games
import XCTest

class APITests: XCTestCase {

    // MARK: - Public Properties
    
    var testData: [String] = []

    // MARK: - Public Functions
    
    override func setUp() {
        super.setUp()
        initialize()
    }

    private func initialize() {

        guard let apiActivePath = Bundle(for: WorkoutListTest.self).url(forResource: "api_active", withExtension: "json"),
            let json1 = try? Data(contentsOf: apiActivePath),
            let apiActiveTrue = String(data: json1, encoding: .ascii) else {
                XCTFail("Failed due to being unable to parse file from disk.")
                return
        }

        guard let apiInactivePath = Bundle(for: WorkoutListTest.self).url(forResource: "api_inactive", withExtension: "json"),
            let json2 = try? Data(contentsOf: apiInactivePath),
            let apiActiveFalse = String(data: json2, encoding: .ascii) else {
                XCTFail("Failed due to being unable to parse file from disk.")
                return
        }

        guard let forceUpdatePath = Bundle(for: WorkoutListTest.self).url(forResource: "force_update", withExtension: "json"),
            let json3 = try? Data(contentsOf: forceUpdatePath),
            let forceUpdateTrue = String(data: json3, encoding: .ascii) else {
                XCTFail("Failed due to being unable to parse file from disk.")
                return
        }

        testData = [apiActiveTrue, apiActiveFalse, forceUpdateTrue]
    }

    func testValidatingHeaders() {
        let headerKey = "CrossFit-API-Status"
        let apiError1 = KillSwitchManager.validateApiStatus(with: [headerKey: testData[0]])
        XCTAssertNil(apiError1)
        let apiError2 = KillSwitchManager.validateApiStatus(with: [headerKey: testData[1]])
        if let apiError2 = apiError2 {
            switch apiError2 {
            case .inactive(title: _, message: _):
                XCTAssertTrue(true)
            default:
                break
            }
        }

        let apiError3 = KillSwitchManager.validateApiStatus(with: [headerKey: testData[2]])
        if let apiError3 = apiError3 {
            switch apiError3 {
            case .forceUpdate(title: _, message: _, storeLink: _):
                XCTAssertTrue(true)
            default:
                break
            }
        }
    }
}
