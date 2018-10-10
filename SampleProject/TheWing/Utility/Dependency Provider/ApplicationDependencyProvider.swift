//
//  ApplicationDependencyProvider.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import Yoshi

/// Manages dependency for this application.
final class ApplicationDependencyProvider: DependencyProvider {

    // MARK: - Public Properties

    /// Providers network access to application's API.
    private(set) var networkProvider: LoaderProvider
    
    /// Analytics provider.
    private(set) var analyticsProvider: AnalyticsProvider

    // MARK: - Private Properties

    /// Environment manager.
    private let environmentManager: YoshiEnvironmentManager<APIEnvironment>

    // MARK: - Initialization

    /// Creates an instance of the dependency provider.
    ///
    /// - Parameters:
    ///   - environmentManager: Environment manager.
    ///   - analyticsProvider: Analytics provider.
    init(environmentManager: YoshiEnvironmentManager<APIEnvironment>,
         analyticsProvider: AnalyticsProvider,
         killSwitchProvider: KillSwitchProvider?) {

        self.environmentManager = environmentManager
        self.analyticsProvider = analyticsProvider

        let decoder = DataDecoder(killSwitchProvider: killSwitchProvider)
        networkProvider = NetworkLoaderProvider(apiEnvironment: environmentManager.currentEnvironment,
                                                httpClient: AlamofireHTTPClient(decoder: decoder))

        environmentManager.onEnvironmentChange = { (environment) in
            self.networkProvider = NetworkLoaderProvider(apiEnvironment: environment,
                                                         httpClient: AlamofireHTTPClient(decoder: decoder))
        }
    }

}
