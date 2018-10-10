//
//  NewRegionFilterTests.swift
//  CrossFit GamesTests
//
//  Created by Daniel Vancura on 1/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

@testable import CrossFit_Games
import XCTest

class NewRegionFilterTests: XCTestCase {

    // MARK: - Private Properties
    
    private static let group = DispatchGroup()

    // MARK: - Public Functions
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testParsing2018Filters() {
        guard let filePath = Bundle(for: NewRegionFilterTests.self).url(forResource: "Open2018Filters", withExtension: "json"),
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

        checkRegionData(testName: #function, data: data, expectingRegions: 19, expectingCountries: 245, expectingUSStates: 57)
    }

    func testStaging2017Data() {
        guard let filePath = Bundle(for: NewRegionFilterTests.self).url(forResource: "filters2017", withExtension: "json"),
            let json = try? Data(contentsOf: filePath) else {
                XCTFail("Failed due to being unable to parse file from disk.")
                return
        }

        let stringValue = String(data: json, encoding: .ascii)
        guard let data = stringValue?.data(using: .utf8) else {
            XCTFail("Whoops")
            return
        }

        checkRegionData(testName: #function, data: data, expectingRegions: 18, expectingCountries: 241, expectingUSStates: 57)
    }

    func testStaging2018Data() {
        guard let filePath = Bundle(for: NewRegionFilterTests.self).url(forResource: "filters2018", withExtension: "json"),
            let json = try? Data(contentsOf: filePath) else {
                XCTFail("Failed due to being unable to parse file from disk.")
                return
        }

        let stringValue = String(data: json, encoding: .ascii)
        guard let data = stringValue?.data(using: .utf8) else {
            XCTFail("Whoops")
            return
        }

        checkRegionData(testName: #function, data: data, expectingRegions: 19, expectingCountries: 245, expectingUSStates: 57)
    }

    private func checkRegionData(testName: String, data: Data, expectingRegions: Int, expectingCountries: Int, expectingUSStates: Int) {
        let expect = expectation(description: "Timout expectation \(testName)")

        let decoder = JSONDecoder()

        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            do {
                XCTAssertNoThrow(try decoder.decode(LeaderboardControls.self, from: data))
                let leaderboardControls = try decoder.decode(LeaderboardControls.self, from: data)

                /// Fittest filters
                let allFittestFilters = leaderboardControls.controls.filter({ (filter) -> Bool in
                    filter.name == "region"
                })

                guard let fittestFilter = allFittestFilters.sorted(by: { (filterA, filterB) -> Bool in
                    filterA.data.count < filterB.data.count
                }).last else {
                    XCTFail("Missing fittest filter in \(testName)")
                    return
                }
                XCTAssertEqual(fittestFilter.data.filter({ (filterOption) in
                    type(of: filterOption) == RegionSelectionFilterData.self
                }).count, 2, "Failed in \(testName)")
                // 2 options: region or countries

                XCTAssertEqual((fittestFilter.data.first(where: { (data) -> Bool in
                    data.value == "region"
                }) as? RegionSelectionFilterData)?.regions.count ?? 0, expectingRegions, "Failed in \(testName)")
                // 18 regions

                XCTAssertEqual((fittestFilter.data.first(where: { (data) -> Bool in
                    data.value == "country"
                }) as? RegionSelectionFilterData)?.regions.count ?? 0, expectingCountries, "Failed in \(testName)")
                // 241 countries to pick from

                XCTAssertEqual(((fittestFilter.data.first(where: { (data) -> Bool in
                    data.value == "country"
                }) as? RegionSelectionFilterData)?.regions.first(where: { (data) -> Bool in
                    data.value == "US"
                }) as? RegionFilterData)?.states?.count, expectingUSStates, "Failed in \(testName)")
            } catch {
                XCTFail("Failed with error: \(error) in \(testName)")
            }

            expect.fulfill()
        }

        waitForExpectations(timeout: 3) { (error) in
            guard error == nil else {
                XCTFail("Timeout while parsing filters in \(testName).")
                return
            }
        }
    }

}
