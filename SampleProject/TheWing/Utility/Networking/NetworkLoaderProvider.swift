//
//  NetworkLoaderProvider.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Handles network requests and contains network client and session.
final class NetworkLoaderProvider: LoaderProvider {

    // MARK: - Public Properties
    
    var membersLoader: CommunityLoader

    var eventsLoader: EventsLoader

    var authLoader: AuthLoader

    var userLoader: ProfileLoader

    var searchResultsLoader: SearchResultsLoader

    var homeLoader: HomeLoader

    let sessionManager = SessionManager()

    let eventLocalCache = EventLocalCache()
    
    // MARK: - Private Properties
    
    private let httpClient: HTTPClient
    private let mockHTTPClient = MockHTTPClient()
    
    // MARK: - Initialization
    
    init(apiEnvironment: APIEnvironment, httpClient: HTTPClient) {
        self.httpClient = httpClient
        
        let data = LoaderData(httpClient: httpClient,
                              mockHTTPClient: mockHTTPClient,
                              apiEnvironment: apiEnvironment,
                              sessionManager: sessionManager,
                              eventLocalCache: eventLocalCache)

        membersLoader = NetworkCommunityLoader(data: data)
        eventsLoader = NetworkEventsLoader(data: data)
        authLoader = NetworkAuthLoader(data: data)
        userLoader = NetworkProfileLoader(data: data)
        searchResultsLoader = NetworkSearchResultsLoader(data: data)
        homeLoader = NetworkHomeLoader(data: data)
    }
    
}
