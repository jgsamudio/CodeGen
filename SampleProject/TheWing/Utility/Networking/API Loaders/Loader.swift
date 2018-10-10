//
//  APILoader.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire

/// Base API Loader class.
class Loader {

	// MARK: - Public Properties

    // MARK: - Public Properties
    
    /// Network HTTP Client.
    let httpClient: HTTPClient

    /// Mock HTTP Client.
    let mockHTTPClient: MockHTTPClient

    /// Current api environment.
    let apiEnvironment: APIEnvironment

    /// Session manager for the application.
    let sessionManager: SessionManager

    /// Local cache for events.
    let eventLocalCache: EventLocalCache

	// MARK: - Initialization

    // MARK: - Initialization
    
    init(data: LoaderData) {
        self.httpClient = data.httpClient
        self.mockHTTPClient = data.mockHTTPClient
        self.apiEnvironment = data.apiEnvironment
        self.sessionManager = data.sessionManager
        self.eventLocalCache = data.eventLocalCache
    }

    // MARK: - Public Functions

    /// A default API request with the given parameters.
    ///
    /// - Parameters:
    ///   - method: HTTP method of the request.
    ///   - endpoint: Endpoint of the request.
    ///   - queryItems: Additional query items that should be added to the endpoint.
    ///   - parameters: Parameters of the network call.
    ///   - headers: Additional headers for the network call.
    /// - Returns: Completed HTTPRequest.
    func apiRequest(method: HTTPMethod,
                    endpoint: String,
                    queryItems: [URLQueryItem]? = nil,
                    parameters: Parameters? = nil,
                    headers: Headers? = nil) -> HTTPRequest {

        var authenticationHeaders: Headers = ["Content-Type": "application/json"]

        if let token = sessionManager.authToken {
            authenticationHeaders["x-access-token"] = token
        }

        return HTTPRequest(method: method,
                           baseURL: apiEnvironment.baseURL,
                           path: endpoint,
                           queryItems: queryItems,
                           parameters: parameters,
                           headers: authenticationHeaders)
    }
    
    /// Returns an endpoint URL with a given path.
    ///
    /// - Parameter path: Path to add to base URL.
    /// - Returns: URL if the endpoint is valid.
    func endpointUrl(path: String) -> URL? {
        let baseUrlString = apiEnvironment.baseURL.absoluteString
        
        if let url = URL(string: baseUrlString + path) {
            return url
        }
        return nil
    }
    
}
