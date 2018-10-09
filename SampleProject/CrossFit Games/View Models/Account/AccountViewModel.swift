//
//  AccountViewModel.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

/// View Model For Account
struct AccountViewModel {

    /// Full Name
    var fullname: String? {
        return userAuthService.userDataStore.userFullname
    }

    /// Email
    var email: String? {
        return userAuthService.userDataStore.userEmail
    }

    /// Data Source for view to consume
    var dataSource: [AccountCellOption] {
        let loginOption: AccountCellOption = userAuthService.userDataStore.isLoggedIn ? .logout: .login
        return [.help, .faq, .contactUs, .ruleBook, .drugPolicy, loginOption]
    }

    private let logoutService = ServiceFactory.shared.createLogoutService()
    private let userAuthService = ServiceFactory.shared.createUserAuthService()

    /// Logs the user out.
    func logout() {
        logoutService.logout()
    }

}
