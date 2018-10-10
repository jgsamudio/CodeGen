//
//  RootViewModel.swift
//  TheWing
//
//  Created by Jonathan Samudio on 2/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Crashlytics
import Foundation

final class RootViewModel {

    // MARK: - Public Properties

    let dependencyProvider: DependencyProvider

    weak var delegate: RootViewDelegate?

    // MARK: - Initialization

    /// Initializes view model with dependencies.
    ///
    /// - Parameter dependencyProvider: Provider for dependencies.
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }

    // MARK: - Public Functions

    /// Checks the status of the user account.
    func checkLoginStatus() {
        if !dependencyProvider.networkProvider.sessionManager.isLoggedIn {
            delegate?.transitionToLogin()
        } else {
            reloadUser()
        }
    }
    
    /// Handle successful login.
    func userLoggedIn() {
        guard let user = dependencyProvider.networkProvider.sessionManager.user else {
            delegate?.transitionToLogin()
            return
        }

        Crashlytics.sharedInstance().setUserIdentifier(user.userId)
        transitionAfterLogin()
    }

    /// Logs user out of the current session.
    func logOutUser() {
        dependencyProvider.networkProvider.sessionManager.logOut()
        dependencyProvider.networkProvider.eventLocalCache.reset()
        UserDefaults.standard.removeObjects([UserDefaultsKeys.eventsFilters, UserDefaultsKeys.communityFilters])
    }

}

// MARK: - Private Functions
private extension RootViewModel {

    func reloadUser() {
        transitionAfterLogin()
        dependencyProvider.networkProvider.authLoader.user { (_) in
            
        }
    }
    
    func transitionAfterLogin() {
        if !UserDefaults.standard.completedOnboarding {
            delegate?.transitionToOnboarding()
        } else {
            delegate?.transitionToMainApp()
        }
    }

}
