//
//  LeaderboardListService.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/20/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Service for retrieving leaderboard lists.
struct LeaderboardListService {

    // MARK: - Public Properties
    
    /// Maximum page size of leaderboard pages.
    static let pageSize = 50

    let httpClient: HTTPClientProtocol

    let dataStore: LeaderboardDataStore

    // MARK: - Private Properties
    
    private static var leaderboardSizes: [CustomLeaderboard: Int] = [:]

    // MARK: - Public Functions
    
    /// Retrieves the number of athletes for the given leaderboard.
    ///
    /// - Parameter leaderboard: Leaderboard to get the number of athletes for.
    /// - Returns: Number of athletes or nil, if no leaderboard page has been loaded yet.
    func numberOfAthletes(for leaderboard: CustomLeaderboard) -> Int? {
        return LeaderboardListService.leaderboardSizes[leaderboard]
    }

    /// Returns a leaderboard list item in the given leaderboard at the given index.
    ///
    /// - Parameters:
    ///   - leaderboard: Leaderboard to search in.
    ///   - index: Index of the athlete in the leaderboard.
    /// - Returns: Leaderboard list item or nil, if not cached yet.
    func athlete(for leaderboard: CustomLeaderboard, atIndex index: Int) -> LeaderboardListItem? {
        let relevantPage = Int(floor(Double(index) / Double(LeaderboardListService.pageSize))) + 1

        guard let page = page(in: leaderboard, page: relevantPage) else {
            return nil
        }

        let indexInPage = index % LeaderboardListService.pageSize
        return page.items[indexInPage]
    }

    /// Returns a leaderboard page for the item at the given index.
    ///
    /// - Parameters:
    ///   - itemIndex: Index of the item.
    ///   - leaderboard: Leaderboard to search in.
    /// - Returns: Leaderboard page with the given item index or nil, if not cached yet.
    func page(for itemIndex: Int, in leaderboard: CustomLeaderboard) -> LeaderboardPage? {
        guard let pageIndex = pageIndex(for: itemIndex, in: leaderboard) else {
            return nil
        }

        return page(in: leaderboard, page: pageIndex)
    }

    /// Returns the page index for the given item index.
    ///
    /// - Parameters:
    ///   - itemIndex: Index of an item in the leaderboard.
    ///   - leaderboard: Leaderboard to search in.
    /// - Returns: Page index of the page that contains the leaderboard list item at the given list index.
    func pageIndex(for itemIndex: Int, in leaderboard: CustomLeaderboard) -> Int? {
        return Int(floor(Double(itemIndex) / Double(LeaderboardListService.pageSize))) + 1
    }

    /// Retrieves and caches a leaderboard list page with the given custom leaderboard and page index.
    ///
    /// - Parameters:
    ///   - customLeaderboard: Leaderboard to retrieve.
    ///   - searchCondition: Search condition for jumping to the appropriate page.
    ///   - completion: Completion block called with the leaderboard page and error.
    func getLeaderboardList(with customLeaderboard: CustomLeaderboard,
                            searchCondition: LeaderboardSearchCondition = .page(pageIndex: 1),
                            completion: @escaping (LeaderboardPage?, Error?) -> Void) {
        let request = LeaderboardRequest(customLeaderboard: customLeaderboard, searchCondition: searchCondition)

        let httpRequest = request.rawValue
        if let leaderboard: LeaderboardPage = httpClient.cachedResponse(of: LeaderboardPageOpenOnline.self, for: request.rawValue)
            ?? httpClient.cachedResponse(of: LeaderboardPageGamesRegionals.self, for: request.rawValue)
            ?? httpClient.cachedResponse(of: LeaderboardPageTeamSeries.self, for: request.rawValue) {
            completion(leaderboard, nil)
            return
        }

        if let urlRequest = httpRequest.urlRequest {
            CFCache.default.needsRefresh.insert(urlRequest)
        }
        httpClient.requestJson(request: httpRequest, isAuthRequest: false) { (data, _, error, _) in
            guard let data = data else {
                completion(nil, error)
                return
            }

            if var leaderboardPage = try? JSONDecoder().decode(LeaderboardPageOpenOnline.self, from: data) {
                // Set as ordinals: Sort filters other than 0 (overall), using enumerated ID 1...n and using the sort filter's display value as
                // the ordinal's display name.
                leaderboardPage.ordinals = self.readOrdinalsFromFilter(customLeaderboard: customLeaderboard)
                self.cache(leaderboardPage: leaderboardPage, for: customLeaderboard, searchCondition: searchCondition)
                self.updateAthleteCount(withPage: leaderboardPage, on: customLeaderboard)
                completion(leaderboardPage, error)
                return
            } else if var leaderboardPage = try? JSONDecoder().decode(LeaderboardPageGamesRegionals.self, from: data) {
                leaderboardPage.ordinals = self.readOrdinalsFromFilter(customLeaderboard: customLeaderboard)
                self.cache(leaderboardPage: leaderboardPage, for: customLeaderboard, searchCondition: searchCondition)
                self.updateAthleteCount(withPage: leaderboardPage, on: customLeaderboard)
                completion(leaderboardPage, error)
                return
            } else if var leaderboardPage = try? JSONDecoder().decode(LeaderboardPageTeamSeries.self, from: data) {
                leaderboardPage.ordinals = self.readOrdinalsFromFilter(customLeaderboard: customLeaderboard)
                self.cache(leaderboardPage: leaderboardPage, for: customLeaderboard, searchCondition: searchCondition)
                self.updateAthleteCount(withPage: leaderboardPage, on: customLeaderboard)
                completion(leaderboardPage, error)
            } else {
                completion(nil, error)
            }
        }
    }

    private func readOrdinalsFromFilter(customLeaderboard: CustomLeaderboard) -> [LeaderboardOrdinal] {
        return customLeaderboard.selectedControls.controls.first(where: { (filter) -> Bool in
            filter.configName == LeaderboardFilter.sortConfigName
        }).flatMap({ (filter) -> [LeaderboardOrdinal]? in
            filter.data.enumerated().flatMap({ (data) -> LeaderboardOrdinal? in
                if data.offset == 0 {
                    return nil
                } else {
                    return LeaderboardOrdinal(id: "\(data.offset)", displayName: data.element.display)
                }
            })
        }) ?? []
    }

    /// Retrieves the ordinal for a workout score and leaderboard page.
    ///
    /// - Parameters:
    ///   - workoutScore: Workout score in question.
    ///   - leaderboard: Leaderboard to load from.
    ///   - page: Page index where the workout score can be found.
    /// - Returns: Leaderboard ordinal (if exists).
    func ordinal(for workoutScore: WorkoutScore, inLeaderboard leaderboard: CustomLeaderboard, onPage page: Int) -> LeaderboardOrdinal? {
        guard let matchingPage = self.page(in: leaderboard, page: page) else {
            return nil
        }

        return matchingPage.ordinals.first(where: { (ordinal) -> Bool in
            return ordinal.id == workoutScore.ordinalID
        })
    }

    /// Caches a leaderboard page that has been returned for a given leaderboard and a search condition.
    ///
    /// If the search condition was to search for an athlete, the response will also be valid for the page that athlete
    /// is on, meaning the response can be cached for two matching keys: `https://request...?athlete=12345` and
    /// `https://request...?page={that athlete's page}`.
    ///
    /// - Parameters:
    ///   - leaderboardPage: Leaderboard page that was returned.
    ///   - leaderboard: Leaderboard that was searched for.
    ///   - searchCondition: Search conditions indicating which page should be loaded or which athlete to search for.
    private func cache<T: LeaderboardPage & Decodable>(leaderboardPage: T,
                                                       for leaderboard: CustomLeaderboard,
                                                       searchCondition: LeaderboardSearchCondition) {
        switch searchCondition {
        case .page(pageIndex: _):
            let httpRequest = LeaderboardRequest(customLeaderboard: leaderboard, searchCondition: searchCondition)
            httpClient.setCachedResponse(leaderboardPage, for: httpRequest.rawValue)
        case .athlete(athleteId: _):
            let athleteRequest = LeaderboardRequest(customLeaderboard: leaderboard, searchCondition: searchCondition)
            httpClient.setCachedResponse(leaderboardPage, for: athleteRequest.rawValue)

            let matchingPageRequest = LeaderboardRequest(customLeaderboard: leaderboard, searchCondition: .page(pageIndex: leaderboardPage.pageIndex))
            httpClient.setCachedResponse(leaderboardPage, for: matchingPageRequest.rawValue)
        }
    }

    private func updateAthleteCount(withPage page: LeaderboardPage, on leaderboard: CustomLeaderboard) {
        if page.totalNumberOfAthletes != 0 {
            LeaderboardListService.leaderboardSizes[leaderboard] = page.totalNumberOfAthletes
        } else if page.totalPageCount == page.pageIndex {
            LeaderboardListService.leaderboardSizes[leaderboard] = page.items.count + LeaderboardListService.pageSize * (page.totalPageCount - 1)
        } else if LeaderboardListService.leaderboardSizes[leaderboard] == nil {
            LeaderboardListService.leaderboardSizes[leaderboard] = page.totalPageCount * LeaderboardListService.pageSize
        }
    }

    private func page(in leaderboard: CustomLeaderboard, page: Int) -> LeaderboardPage? {
        let request = LeaderboardRequest(customLeaderboard: leaderboard, searchCondition: .page(pageIndex: page))

        return httpClient.cachedResponse(of: LeaderboardPageOpenOnline.self, for: request.rawValue)
            ?? httpClient.cachedResponse(of: LeaderboardPageGamesRegionals.self, for: request.rawValue)
            ?? httpClient.cachedResponse(of: LeaderboardPageTeamSeries.self, for: request.rawValue)
    }

}
