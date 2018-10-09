//
//  RootViewModel.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/16/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// View model for root view controller determination.
struct RootViewModel {

    private let logoutService: LogoutService
    
    private let userAuthService: UserAuthService

    private let sessionService: SessionService

    init() {
        self.init(logoutService: ServiceFactory.shared.createLogoutService(),
                  userAuthService: ServiceFactory.shared.createUserAuthService(),
                  sessionService: ServiceFactory.shared.createSessionService())
    }

    init(logoutService: LogoutService,
         userAuthService: UserAuthService,
         sessionService: SessionService) {
        self.logoutService = logoutService
        self.userAuthService = userAuthService
        self.sessionService = sessionService
    }
    
    /// Determines if user is currently logged in
    var isLoggedIn: Bool {
        return sessionService.isLoggedIn
    }

    /// Logs the user out.
    func logout() {
        logoutService.logout()
    }

}
