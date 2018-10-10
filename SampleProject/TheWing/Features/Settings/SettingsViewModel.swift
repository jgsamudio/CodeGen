//
//  SettingsViewModel.swift
//  TheWing
//
//  Created by Luna An on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class SettingsViewModel {

    // MARK: - Public Properties

    /// Binding delegate for the view model.
    weak var delegate: SettingsViewDelegate?

    // MARK: - Private Properties

    private let dependencyProvider: DependencyProvider
    
    private let settingsAnalyticsProvider: SettingsAnalyticsProvider
    
    // MARK: - Initialization

    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
        settingsAnalyticsProvider = SettingsAnalyticsProvider(dependencyProvider: dependencyProvider)
    }
    
    // MARK: - Public Functions

    /// Called when the menu item is selected.
    ///
    /// - Parameter settingsItem: Selected settings item.
    func menuItemSelected(settingsItem: SettingsItem) {
        switch settingsItem {
        case .rateAtAppStore:
            delegate?.rateUsAtTheAppStoreSelected()
        case .contactUs:
            delegate?.contactUsSelected(email: BusinessConstants.loggedInContactEmailAddress)
        case .announcements(let isOn):
            delegate?.toggleAnnouncementsNotification(isOn)
        case .eventReminders(let isOn):
            delegate?.toggleHappeningsRemindersNotification(isOn)
        case .logout:
            delegate?.logOutSelected()
        }
    }
    
    /// Updates user defaults data with switch type and its on/off state.
    ///
    /// - Parameters:
    ///   - switchType: Settings switch type. ( e.g. events, announcements )
    ///   - isOn: Indicates if the switch is on or off.
    func updateUserDefaults(switchType: SettingsSwitchType, isOn: Bool) {
        switch switchType {
        case .announcements:
            UserDefaults.standard.pushAnnoucements = isOn
        case .events:
            UserDefaults.standard.pushHappenings = isOn
        }
    }
    
    /// Identifies user traits from switch type. Used for analytics.
    ///
    /// - Parameter switchType: Settings switch type. ( e.g. events, announcements )
    func identifyUserTraits(from switchType: SettingsSwitchType) {
        settingsAnalyticsProvider.identifyUserTraits(from: switchType)
    }
    
}
