//
//  ServiceFactory.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/20/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Alamofire
import Foundation

/// Factory for creating services - single instances of classes that allow a developer to perform business-goal related
/// tasks.
struct ServiceFactory {

    // MARK: - Public Properties
    
    /// Shared instance of `self`.
    static let shared = ServiceFactory()

    // MARK: - Private Properties
    
    private let authHttpClient: AuthHTTPClient
    private let defaultHTTPClient: HTTPClientProtocol
    private let userDataStore: UserDataStore
    private let leaderboardDataStore: LeaderboardDataStore
    private let keychainDataStore: KeychainDataStore
    private let workoutDataStore: WorkoutDataStore
    private let competitionInfoDataStore: CompetitionInfoDataStore

    // MARK: - Initialization
    
    private init() {
        authHttpClient = AuthHTTPClient(sessionManager: ServiceFactory.createSessionManager())
        defaultHTTPClient = DefaultHTTPClient(sessionManager: ServiceFactory.createSessionManager())
        userDataStore = UserDataStore()
        leaderboardDataStore = LeaderboardDataStore()
        keychainDataStore = KeychainDataStore()
        workoutDataStore = WorkoutDataStore()
        competitionInfoDataStore = CompetitionInfoDataStore()
        userDataStore.keychainDataStore = keychainDataStore
    }

    // MARK: - Public Functions
    
    /// Creates a service that is capable of creating new user account.
    ///
    /// - Returns: New instance of the requested service.
    func createAccountService() -> CreateAccountService {
        return CreateAccountService(httpClient: authHttpClient,
                                    userDataStore: userDataStore)
    }

    /// Creates a service that is capable of authorizing users.
    ///
    /// - Returns: New instance of the requested service.
    func createUserAuthService() -> UserAuthService {
        return UserAuthService(httpClient: defaultHTTPClient,
                               userDataStore: userDataStore,
                               authClient: authHttpClient,
                               keychainDataStore: keychainDataStore,
                               sessionService: createSessionService())
    }

    /// Creates a service that is capable of retrieving personalized leaderboard service
    ///
    /// - Returns: New instance of the requested service.
    func createPersonalizedLeaderboardService(userID: String) -> PersonalizedLeaderboardService {
        return PersonalizedLeaderboardService(httpClient: defaultHTTPClient, userID: userID)
    }

    /// Creates and returns a service useful for filtering leaderboards.
    ///
    /// - Returns: New instance of the requested service.
    func createLeaderboardFilterService() -> LeaderboardFilterService {
        return LeaderboardFilterService(competitionInfoService: createCompetitionInfoService(), httpClient: defaultHTTPClient)
    }

    /// Creates and returns a service useful for saving leaderboard filter selections.
    ///
    /// - Returns: New instance of the requested service.
    func createLeaderboardFilterPersistenceService() -> LeaderboardFilterPersistenceService {
        return LeaderboardFilterPersistenceService(dataStore: leaderboardDataStore)
    }

    /// Creates a service for retrieving leaderboard lists.
    ///
    /// - Returns: New instance of the requested service.
    func createLeaderboardListService() -> LeaderboardListService {
        return LeaderboardListService(httpClient: defaultHTTPClient, dataStore: leaderboardDataStore)
    }

    /// Creates a service for interacting with the secure keychain.
    ///
    /// - Returns: New instance of the requested service.
    func createKeychainService() -> KeychainService {
        return KeychainService(keychainDataStore: keychainDataStore)
    }

    /// Service for logging out a user and erasing data for that user.
    ///
    /// - Returns: New instance of the requested service.
    func createLogoutService() -> LogoutService {
        return LogoutService(leaderboardDataStore: leaderboardDataStore,
                             userDataStore: userDataStore,
                             keychainDataStore: keychainDataStore,
                             authHttpClient: authHttpClient,
                             competitionInfoDataStore: competitionInfoDataStore)
    }

    /// Creates a service for making filter selections on a leaderboard.
    ///
    /// - Parameter controls: Controls that are available for selection.
    /// - Returns: New instance of the requested service.
    func createLeaderboardFilterSelectionService(with controls: [LeaderboardControls],
                                                 selectedControls: LeaderboardControls? = nil,
                                                 preselection: [LeaderboardFilterSelection] = [],
                                                 affiliateId: String?) -> LeaderboardFilterSelectionService? {
        return LeaderboardFilterSelectionService(controls: controls,
                                                 selectedControls: selectedControls,
                                                 preselection: preselection,
                                                 competitionInfoSerivce: createCompetitionInfoService(),
                                                 affiliateId: affiliateId)
    }

    /// Creates a service for workout list related activity
    ///
    /// - Returns: New instance of workout service
    func createWorkoutsService() -> WorkoutsService {
        return WorkoutsService(httpClient: defaultHTTPClient, dataStore: workoutDataStore)
    }

    /// Creates a service for workout list related activity
    ///
    /// - Returns: New instance of workout service
    func createLeaderboardSearchService() -> LeaderboardSearchService {
        return LeaderboardSearchService(httpClient: defaultHTTPClient)
    }

    /// Creates a service for retrieving session information.
    ///
    /// - Returns: New instance of session service.
    func createSessionService() -> SessionService {
        return SessionService(userDataStore: userDataStore, keychainDataStore: keychainDataStore, httpClient: defaultHTTPClient)
    }

    /// Creates a service for setting and retrieving competition information.
    ///
    /// - Returns: New instance of competition info service.
    func createCompetitionInfoService() -> CompetitionInfoService {
        return CompetitionInfoService(dataStore: competitionInfoDataStore)
    }

    /// Returns a service to show iFrames for submitting scores.
    ///
    /// - Returns: Service to submit scores via iFrame.
    func createSubmitScoreService() -> SubmitScoreService {
        return SubmitScoreService(sessionService: createSessionService())
    }

    /// Returns a service to get remote configurations.
    ///
    /// - Returns: Service to get remote configurations.
    func createRemoteConfigService() -> RemoteConfigService {
        return RemoteConfigService()
    }

    /// Returns a service for follow an athlete.
    ///
    /// - Returns: Service for follow an athlete activities.
    func createFollowAnAthleteService() -> FolllowAnAthleteService {
        return FolllowAnAthleteService()
    }

    private static func createSessionManager() -> SessionManager {
        let result = SessionManager()
        // This will ensure that requests are only sent if there is an actual completion handler.
        result.startRequestsImmediately = false
        return result
    }

}
