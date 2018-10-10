//
//  LogoutService.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/16/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import Simcoe

/// Service for logging out the user.
struct LogoutService {

    // MARK: - Private Properties
    
    private let leaderboardDataStore: LeaderboardDataStore

    private let userDataStore: UserDataStore

    private let keychainDataStore: KeychainDataStore

    private let authHttpClient: AuthHTTPClient

    private let competitionInfoDataStore: CompetitionInfoDataStore

    // MARK: - Initialization
    
    /// Initalizer
    ///
    /// - Parameters:
    ///   - leaderboardDataStore: LeaderboardDataStore
    ///   - userDataStore: UserDataStore
    ///   - keychainDataStore: KeychainDataStore
    ///   - authHttpClient: AuthHTTPClient
    init(leaderboardDataStore: LeaderboardDataStore,
         userDataStore: UserDataStore,
         keychainDataStore: KeychainDataStore,
         authHttpClient: AuthHTTPClient,
         competitionInfoDataStore: CompetitionInfoDataStore) {
        self.leaderboardDataStore = leaderboardDataStore
        self.userDataStore = userDataStore
        self.keychainDataStore = keychainDataStore
        self.authHttpClient = authHttpClient
        self.competitionInfoDataStore = competitionInfoDataStore
    }

    // MARK: - Public Functions
    
    /// Logs out the user and wipes all user-centered data.
    func logout() {
        keychainDataStore.deleteAll()
        userDataStore.createAccountUser = nil
        userDataStore.detailedUser = nil
        authHttpClient.oAuthManager.accessToken = nil
        Simcoe.setUserAttributes(UserAnalyticsProperties(personalizedLeaderboard: nil).rawValue)
        CrashlyticsIntegration.shared.setUserId(nil)
        UserDefaultsManager.shared.setValue(withKey: .accessTokenExpirationDate, value: nil)
        competitionInfoDataStore.personalizedLeaderboard = nil
    }

}
