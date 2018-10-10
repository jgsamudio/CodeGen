//
//  OAuthRetrier.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/20/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import Alamofire
import Foundation
import Keys

class OAuthManager: RequestRetrier, RequestAdapter {

    // MARK: - Public Properties
    
    /// Access token that is get / set from user defaults always
    var accessToken: String? {
        get {
            return UserDefaultsManager.shared.getValue(byKey: .userAccessToken) as? String
        }
        set (newValue) {
            UserDefaultsManager.shared.setValue(withKey: .userAccessToken, value: newValue)
        }
    }

    // MARK: - Initialization
    
    init(sessionManager: SessionManager) {
        sessionManager.adapter = self
        sessionManager.retrier = self
    }

    // MARK: - Public Functions
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var request = urlRequest
        if request.value(forHTTPHeaderField: "Authorization") == nil {
            request.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        }

        guard let url = urlRequest.url, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return request
        }

        var items = urlComponents.queryItems ?? []
        items.append(URLQueryItem(name: "mobile-app-client", value: "1"))
        urlComponents.queryItems = items
        request.url = urlComponents.url ?? request.url

        return request
    }

    func should(_ manager: SessionManager,
                retry request: Request,
                with error: Error,
                completion: @escaping RequestRetryCompletion) {
        switch error {
        case let val as AFError:
            if val.responseCode == 401 {
                refreshAccessToken(completion: { (error) in
                    guard error == nil else {
                        completion(false, 0)
                        return
                    }

                    completion(true, 0)
                })
            } else {
                completion(false, 0)
            }
        default:
            completion(false, 0)
        }
    }

    private func refreshAccessToken(completion: @escaping (Error?) -> Void) {
        let keychainService = ServiceFactory.shared.createKeychainService()
        let sessionService = ServiceFactory.shared.createSessionService()
        if let email = keychainService.value(for: .username),
            let password = keychainService.value(for: .password) {
            sessionService.refreshSession(email: email,
                                          password: password,
                                          completion: { (error) in
                                            completion(error)
            })
        } else {
            completion(AuthError.noSavedCredentials)
        }
    }

}
