//
//  RemoteConfigService.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 2/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

/// Service for setting up remote configuration of the app.
final class RemoteConfigService {

    private var config: FirebaseRemoteConfig.RemoteConfig

    init() {
        FirebaseInstance.setupIfNeeded()
        config = FirebaseRemoteConfig.RemoteConfig.remoteConfig()
    }

    /// Runs the remote configuration, downloading the latest config.
    func remoteConfig() {
        config = FirebaseRemoteConfig.RemoteConfig.remoteConfig()
    }

    /// Fetches remote config and sets it locally if the request succeeds.
    ///
    /// - Parameters:
    ///   - completion: Completion block that is called with any errors that might have occurred.
    func fetch(completion: @escaping (RemoteConfig?, Error?) -> Void) {
        config.fetch(withExpirationDuration: 0) { [weak self] (status, error) in
            switch status {
            case .success:
                self?.config.activateFetched()
            default:
                break
            }

            completion((self?.config).flatMap(RemoteConfig.init), error)
        }
    }

}
