//
//  MainTabBarViewModel.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class MainTabBarViewModel {

    // MARK: - Public Properties
    
    /// User id used to initialize profile view model which is used to initialize profile view controller
    /// from profile selected protocol function when user taps on their own profile from the drawer
    var userId: String? {
        return dependencyProvider.networkProvider.sessionManager.user?.userId
    }

    /// Binding delegate for the view model.
    weak var delegate: MainTabBarViewDelegate?
    
    /// Image url for the profile image.
    var profileImageUrlString: String? {
        return dependencyProvider.networkProvider.sessionManager.user?.profile.photo
    }

    // MARK: - Private Properties

    private let dependencyProvider: DependencyProvider
    
    // MARK: - Initialization

    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }

    // MARK: - Public Functions

    /// Called when the menu item is selected.
    ///
    /// - Parameter type: Type of the menu item.
    func menuItemSelected(type: MenuItemType) {
        switch type {
        case .contactUs:
            delegate?.contactUsSelected(email: BusinessConstants.loggedInContactEmailAddress)
        case .settings:
            delegate?.settingsSelected()
        case .privacy:
            if let url = BusinessConstants.privacyPolicyURL {
                delegate?.privacyPolicySelected(url: url)
            }
        case .termsConditions:
            if let url = BusinessConstants.termsAndConditionsURL {
                delegate?.termsAndConditionsSelected(url: url)
            }
        case .houseRules:
            delegate?.houseRulesSelected()
        }
    }

}
