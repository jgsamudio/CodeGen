//
//  StringTests.swift
//  CrossFit GamesTests
//
//  Created by Malinka S on 1/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

@testable import CrossFit_Games
import XCTest

class StringTests: XCTestCase {

    func testVersionComparison() {
        /*
        Test1: version1 = 1.0 version2 = 1.00 -> 0
        Test2: version1 = 1 version2 = 1 -> 0
        Test3: version1 = 1.0.0 version2 = 1.1.0 -> -1
        Test4 version1 = 2.0.0 version2 = 1.0.0 -> 1
        Test5 version1 = 2.045.0 version2 = 1.4.56 -> 1
        Test6 version1 = 12.045.0 version2 = 19.4.561 -> 1
        */

        XCTAssertEqual(String.compareVersions(version1: "1.0", version2: "1.0.0"), ComparisonResult.orderedSame)
        XCTAssertEqual(String.compareVersions(version1: "1", version2: "1"), ComparisonResult.orderedSame)
        XCTAssertEqual(String.compareVersions(version1: "1.0.0", version2: "1.1.0"), ComparisonResult.orderedAscending)
        XCTAssertEqual(String.compareVersions(version1: "2.0.0", version2: "1.0.0"), ComparisonResult.orderedDescending)
        XCTAssertEqual(String.compareVersions(version1: "2.045.0", version2: "1.4.56"), ComparisonResult.orderedDescending)
        XCTAssertEqual(String.compareVersions(version1: "12.045.0", version2: "19.4.561"), ComparisonResult.orderedAscending)
    }

    func testDateConversion() {
        let formatter = CustomDateFormatter.apiDateFormatter
        let date1: String = "2015-12-30T01:00:00+0000"
        let date2: String = "-0001-11-30T00:00:00+0000"
        let date3: String = "2015-12-30T01:00:00"
        XCTAssertTrue(date1.toCurrentDate(dateFormatter: formatter) != nil)
        XCTAssertNil(date2.toCurrentDate(dateFormatter: formatter))
        XCTAssertNil(date3.toCurrentDate(dateFormatter: formatter))
    }
}
