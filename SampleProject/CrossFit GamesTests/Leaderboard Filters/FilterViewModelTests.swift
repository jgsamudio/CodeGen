//
//  FilterViewModelTests.swift
//  CrossFit GamesTests
//
//  Created by Daniel Vancura on 11/27/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

@testable import CrossFit_Games
import Alamofire
import XCTest

private class HTTPClient: HTTPClientProtocol {

    let sessionManager: SessionManager = SessionManager()

    func requestJson(request: HTTPRequest, isAuthRequest: Bool, completion: @escaping (Data?, Int?, Error?, [String: Any]?) -> Void) {
        guard let filePath = Bundle(for: LeaderboardFilterTests.self).url(forResource: "AllFilterControls", withExtension: "json"),
            let json = try? Data(contentsOf: filePath) else {
                XCTFail("Failed due to being unable to parse file from disk.")
                return
        }

        let stringValue = String(data: json, encoding: .ascii)
        guard let data = stringValue?.data(using: .utf8) else {
            XCTFail("Whoops")
            return
        }

        completion(data, 200, nil, nil)
    }

}

class FilterViewModelTests: XCTestCase {

    var httpClient: HTTPClientProtocol!

    override func setUp() {
        super.setUp()

        httpClient = HTTPClient()
    }

    override func tearDown() {
        super.tearDown()

        httpClient = nil
    }

    func testParsingFilters() {
        let expect = expectation(description: "Parsing filters")
        let dataStore = LeaderboardDataStore()
        let filterService = LeaderboardFilterService(competitionInfoService: ServiceFactory.shared.createCompetitionInfoService(),
                                                     httpClient: httpClient)
        let persistenceService = LeaderboardFilterPersistenceService(dataStore: dataStore)
        let filterViewModel = LeaderboardFilterContent(leaderboardFilterService: filterService,
                                                       leaderboardFilterPersistenceService: persistenceService,
                                                       leaderboardFilterSelectionService: nil)
        XCTAssertEqual(filterViewModel.selectionOptions.count, 0)
        filterViewModel.loadFiltersIfNeeded { (error) in
            XCTAssertNil(error)
            let selectionOptions = filterViewModel.selectionOptions

            XCTAssertTrue(selectionOptions.map { $0.title }.sorted().elementsEqual([
                "Competition", "Division", "Fittest in", "Occupation", "Sort", "Workout Type", "Year"
                ]), "\(selectionOptions.map { $0.title }.sorted()) not correct")

            XCTAssertTrue(selectionOptions.contains(where: { (option) -> Bool in
                option.title == "Division"
            }))
            XCTAssertTrue(selectionOptions.contains(where: { (option) -> Bool in
                option.title == "Fittest in"
            }))
            XCTAssertTrue(selectionOptions.contains(where: { (option) -> Bool in
                option.title == "Competition"
            }))
            XCTAssertTrue(selectionOptions.contains(where: { (option) -> Bool in
                option.title == "Year"
            }))
            XCTAssertTrue(selectionOptions.contains(where: { (option) -> Bool in
                option.title == "Workout Type"
            }))
            XCTAssertTrue(selectionOptions.contains(where: { (option) -> Bool in
                option.title == "Occupation"
            }))
            XCTAssertTrue(selectionOptions.contains(where: { (option) -> Bool in
                option.title == "Sort"
            }))

            if let divisionOption = selectionOptions.first(where: { (option) -> Bool in
                option.title == "Division"
            }) as? FilterViewModelNestedOption {
                [
                    "Individual Women", "Individual Men", "Teenage Girls (14-15)", "Teenage Boys (14-15)", "Teenage Girls (16-17)",
                    "Teenage Boys (16-17)", "Masters Women (35-39)"
                    ].forEach({ (divisionName) in
                        XCTAssertTrue(divisionOption.nestedOptions.map { $0.title }.contains(divisionName),
                                      "\(divisionOption.nestedOptions.map { $0.title }) does not contain \(divisionName)")
                    })
            } else {
                XCTFail("Division should be a nested filter option")
            }

            if let fittestOption = selectionOptions.first(where: { (option) -> Bool in
                option.title == "Fittest in"
            }) as? FilterViewModelNestedOption {
                [
                    "Region", "US States", "Canadian Provinces", "Country", "Australian States"
                    ].forEach({ (regionName) in
                        XCTAssertTrue(fittestOption.nestedOptions.map { $0.title }.contains(regionName))
                    })
            } else {
                XCTFail("Fittest in should be a nested filter option")
            }

            if let fittestOption = selectionOptions.first(where: { (option) -> Bool in
                option.title == "Fittest in"
            }) as? FilterViewModelNestedOption, let usStateOptions = fittestOption.nestedOptions.first(where: { (option) -> Bool in
                option.title == "US States"
            }) as? FilterViewModelNestedOption {
                [
                    "Alaska", "California", "Nevada", "New York"
                    ].forEach({ (stateName) in
                        XCTAssertTrue(usStateOptions.nestedOptions.map { $0.title }.contains(stateName))
                    })
            } else {
                XCTFail("Fittest in should be a nested filter option")
            }
            expect.fulfill()
        }

        waitForExpectations(timeout: 3) { (error) in
            XCTAssertNil(error)
        }
    }

}
