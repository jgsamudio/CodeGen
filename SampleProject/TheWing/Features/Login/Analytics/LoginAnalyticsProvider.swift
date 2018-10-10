//
//  LoginAnalyticsProvider.swift
//  TheWing
//
//  Created by Luna An on 8/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class LoginAnalyticsProvider: LoginAnalyticsDelegate {
    
    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider
        
    private let userAttributesData = UserAttributesData.shared
    
    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions
    
    func identifyUserTraits() {
        guard let user = dependencyProvider.networkProvider.sessionManager.user else {
            return
        }
        
        dependencyProvider.analyticsProvider.identify(userId: user.userId,
                                                      userTraits: userAttributesData.userTraits)
    }
    
    func trackLoginEvent() {
        dependencyProvider.analyticsProvider.track(event: AnalyticsConstants.loginEvent,
                                                   properties: userAttributesData.userTraits,
                                                   options: nil)
    }
    
    func captureScreenInformation() {
        dependencyProvider.analyticsProvider.screen(screenTitle: AnalyticsConstants.loginLocation,
                                                    properties: nil,
                                                    options: nil)
    }
    
}
