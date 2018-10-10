//
//  DateTests.swift
//  CrossFit GamesTests
//
//  Created by Daniel Vancura on 10/30/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import XCTest
@testable import CrossFit_Games

class DateTests: XCTestCase {

    // MARK: - Public Functions
    
    func testDateParsing() {
    
    // MARK: - Public Properties
    
        // This is a known value from the test data for workouts API.
        // This value should match the date below (03/27/2017, 17:00:00) as this was the submission date for the related workout.
        let crossFitStandardTime: Int64 = 1490659200

        guard let date = Date(crossFitStandardTime: Int(crossFitStandardTime)) else {
            XCTFail("Failed to create date with valid time.")
            return
        }

        let resultDateFormatter = DateFormatter()
        resultDateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        resultDateFormatter.timeZone = TimeZone(abbreviation: "PST")

        XCTAssertEqual(resultDateFormatter.string(from: date), "03/27/2017 17:00:00")
    }

}
