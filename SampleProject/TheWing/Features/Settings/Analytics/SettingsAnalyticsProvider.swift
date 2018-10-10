//
//  SettingsAnalyticsProvider.swift
//  TheWing
//
//  Created by Luna An on 8/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class SettingsAnalyticsProvider {
    
    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider
    
    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
}

// MARK: - SettingsAnalyticsDelegate
extension SettingsAnalyticsProvider: SettingsAnalyticsDelegate {
    
    // MARK: - Public Functions
    
    func identifyUserTraits(from switchType: SettingsSwitchType) {
        guard let user = dependencyProvider.networkProvider.sessionManager.user else {
            return
        }
        
        dependencyProvider.analyticsProvider.identify(userId: user.userId, userTraits: UserAttributesData.shared.userTraits)
    }
    
}
