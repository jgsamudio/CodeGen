//
//  PersonalizedLeaderboardTests.swift
//  CrossFit GamesTests
//
//  Created by Daniel Vancura on 1/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

@testable import CrossFit_Games
import XCTest
import Alamofire

private struct PersonalizedLeaderboard2018HTTPClient: HTTPClientProtocol {

    let sessionManager: SessionManager = SessionManager()

    private var dummyCache: [URLRequest: Any] = [:]

    func requestJson(request: HTTPRequest, isAuthRequest: Bool, completion: @escaping (Data?, Int?, Error?, [String: Any]?) -> Void) {
        guard let url = Bundle(for: PersonalizedLeaderboardTests.self).url(forResource: "PersonalizedLeaderboard2018", withExtension: "json") else {
            XCTFail("Failed to load test data.")
            return
        }

        completion(try? Data(contentsOf: url), 200, nil, nil)
    }

}

class PersonalizedLeaderboardTests: XCTestCase {

    var testJson: Data!
    
    override func setUp() {
        super.setUp()
        guard let url = Bundle(for: PersonalizedLeaderboardTests.self).url(forResource: "PersonalizedLeaderboard2018", withExtension: "json") else {
            XCTFail("Failed to load test data.")
            return
        }

        do {
            testJson = try Data(contentsOf: url)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    override func tearDown() {
        testJson = nil
        super.tearDown()
    }
    
    /// Tests correct information being parsed.
    func testLoadPersonalizedLeaderboard() {
        let jsonDecoder = JSONDecoder()
        do {
            try XCTAssertNoThrow(jsonDecoder.decode(PersonalizedLeaderboard.self, from: testJson))

            let personalizedLeaderboard = try jsonDecoder.decode(PersonalizedLeaderboard.self, from: testJson)
            XCTAssertEqual(personalizedLeaderboard.teamId, 11119)
            XCTAssertEqual(personalizedLeaderboard.gender, "M")
            XCTAssertEqual(personalizedLeaderboard.countryName, "US")
            XCTAssertEqual(personalizedLeaderboard.stateName, "NY")
            XCTAssertEqual(personalizedLeaderboard.competitionAge, "34")
            XCTAssertEqual(personalizedLeaderboard.firstName, "Ryan")
            XCTAssertEqual(personalizedLeaderboard.competitorName, "Ryan Aker")
            XCTAssertEqual(personalizedLeaderboard.affiliateId, 837)
            XCTAssertEqual(personalizedLeaderboard.stats?.open?.count, 7)
            XCTAssertEqual(personalizedLeaderboard
                .mostRecentStartedOpenCompetition(using: ServiceFactory.shared.createCompetitionInfoService())?.year, "2017")
            XCTAssertEqual(personalizedLeaderboard.mostRecentOpenCompetition?.year, "2018")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test2018NotStartedDashboardCardViewModelCreation() {
        let expect = expectation(description: "Response expectation.")
        let jsonDecoder = JSONDecoder()
        let userDataStore = UserDataStore()
        let keychainDataStore = KeychainDataStore()
        if let data = Bundle(for: PersonalizedLeaderboardTests.self).url(forResource: "LoginData", withExtension: "json").flatMap({ (url) -> Data? in
            return try? Data(contentsOf: url)
        }) {
            userDataStore.detailedUser = try? jsonDecoder.decode(DetailedUser.self, from: data)
        } else {
            XCTFail("Failed to read user data")
        }
        let dummyHTTPClient = PersonalizedLeaderboard2018HTTPClient()
        let personalizedLeaderboardService = PersonalizedLeaderboardService(httpClient: dummyHTTPClient, userID: "1917")

        let userAuthService = UserAuthService(httpClient: dummyHTTPClient,
                                              userDataStore: userDataStore,
                                              authClient: AuthHTTPClient(sessionManager: SessionManager.default),
                                              keychainDataStore: keychainDataStore,
                                              sessionService: SessionService(userDataStore: userDataStore,
                                                                             keychainDataStore: keychainDataStore,
                                                                             httpClient: dummyHTTPClient))
        let dashboardViewModel = DashboardViewModel(userAuthService: userAuthService,
                                                    leaderboardService: personalizedLeaderboardService,
                                                    competitionInfoService: ServiceFactory.shared.createCompetitionInfoService(),
                                                    leaderboardFilterService: ServiceFactory.shared.createLeaderboardFilterService(),
                                                    remoteConfigService: ServiceFactory.shared.createRemoteConfigService(),
                                                    followAnAthleteService: ServiceFactory.shared.createFollowAnAthleteService(),
                                                    leaderboardListService: ServiceFactory.shared.createLeaderboardListService())
        dashboardViewModel.retrievePersonalizedLeaderboard(completion: { (viewModels, leaderboard, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(leaderboard)
            XCTAssertNotNil(viewModels)

            XCTAssertEqual(viewModels?.count, 3)
            XCTAssertTrue((viewModels?.map { $0.year } ?? []).elementsEqual(["2017", "2017", "2017"]))
            XCTAssertTrue((viewModels?.map { $0.rank } ?? []).elementsEqual(["45671", "1852", "5"]))

            expect.fulfill()
        })

        waitForExpectations(timeout: 3) { (error) in
            XCTAssertNil(error)
        }
    }

}
