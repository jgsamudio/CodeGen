//
//  HTTPClient.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/20/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import Alamofire
import Foundation

/// Protocol for HTTP clients.
protocol HTTPClientProtocol {

    /// Session manager of `self`.
    var sessionManager: SessionManager { get }

    /// Performs a request expecting a JSON response and appropriately creates an appropriate object from the response.
    ///
    /// - Parameters:
    ///   - request: Request to be performed.
    ///   - isAuthRequest: Specifies if it's an auth request.
    ///   - completion: Completion handler that is called with either the entity or an error.
    func requestJson<Entity: Decodable>(request: HTTPRequest, isAuthRequest: Bool, completion: @escaping (Entity?, Int?, Error?) -> Void)

    /// Performs a request expecting a Data response.
    ///
    /// - Parameters:
    ///   - request: Request to be performed.
    ///   - isAuthRequest: Specifies if it's an auth request.
    ///   - completion: Completion handler that is called with either the data or an error.
    func requestJson(request: HTTPRequest, isAuthRequest: Bool, completion: @escaping (Data?, Int?, Error?, [String: Any]?) -> Void)

    /// Sets the given object as cached value for the request as key.
    ///
    /// - Parameters:
    ///   - object: Object to cache.
    ///   - request: Request to use as key for the cached value.
    func setCachedResponse<T: Decodable>(_ object: T, for request: HTTPRequest)

    /// Retrieves cached responses for the given request.
    ///
    /// - Parameter request: Request for which to get a cached response.
    /// - Returns: Cached response (if available)
    func cachedResponse<T: Decodable>(of type: T.Type, for request: HTTPRequest) -> T?

    /// Returns a cached response with the gi ven conditions of the HTTP request.
    ///
    /// - Parameter clause: Condition for the key under which the response was cached.
    /// - Returns: Matching cached response.
    func cachedResponse<T: Decodable>(where clause: (URLRequest) -> Bool) -> [T]

}

extension HTTPClientProtocol {

    // MARK: - Public Functions
    
    func requestJson(request: HTTPRequest, isAuthRequest: Bool, completion: @escaping (Data?, Int?, Error?, [String: Any]?) -> Void) {
        /// Show activity indicator in status bar
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    // MARK: - Public Properties
    
        let afRequest = sessionManager.request(request.url,
                                               method: request.method,
                                               parameters: request.body,
                                               encoding: request.encoding,
                                               headers: request.headers)
        afRequest.validate().responseJSON { (response) in
            /// hide activity indicator in status bar
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            DispatchQueue.main.async {
                completion(response.data, response.response?.statusCode, response.error, response.response?.allHeaderFields as? [String: Any])
            }
        }.resume()
    }

    func requestJson<Entity: Decodable>(request: HTTPRequest, isAuthRequest: Bool, completion: @escaping (Entity?, Int?, Error?) -> Void) {
        if let urlRequest = request.urlRequest,
            let parsedEntity: Entity = CFCache.default[urlRequest] as? Entity,
            !CFCache.default.needsRefresh.contains(urlRequest) {
            completion(parsedEntity, nil, nil)
            return
        }

        requestJson(request: request, isAuthRequest: isAuthRequest) { (data, code, error, headers) in
            let headers = headers ?? [:]

            if KillSwitchManager.needsAPIStatusCheck(code: code ?? 200, isAuthRequest: isAuthRequest) {
                KillSwitchManager.checkAPIStatus(completion: { (apiError) in
                    completion(nil, code, apiError ?? error)
                })
                return
            }

            guard let data = data else {
                completion(nil, code, error)
                return
            }

            if let apiError = KillSwitchManager.validateApiStatus(with: headers) {
                completion(nil, code, apiError)
                return
            }

            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Entity.self, from: data)

                if let rawRequest = request.urlRequest,
                    request.allowCaching {
                    CFCache.default[rawRequest] = result
                    CFCache.default.needsRefresh.remove(rawRequest)
                }
                completion(result, code, error)
            } catch {
                completion(nil, code, error)
            }

        }
    }

    func setCachedResponse<T: Decodable>(_ object: T, for request: HTTPRequest) {
        guard let rawRequest = request.urlRequest else {
            return
        }
        CFCache.default[rawRequest] = object
    }

    func cachedResponse<T: Decodable>(of type: T.Type, for request: HTTPRequest) -> T? {
        guard let urlRequest = request.urlRequest else {
            return nil
        }

        if let parsedResponse = CFCache.default[urlRequest] as? T {
            return parsedResponse
        } else {
            return nil
        }
    }

    func cachedResponse<T: Decodable>(where clause: (URLRequest) -> Bool) -> [T] {
        let matchingKeys = CFCache.default.keys.filter(clause)

        return matchingKeys.flatMap { CFCache.default[$0] as? T }
    }

}
