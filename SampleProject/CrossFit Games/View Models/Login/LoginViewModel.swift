//
//  LoginViewModel.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/26/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// The view model for the LoginViewController, which communicates with the
/// service layer
struct LoginViewModel {

    // MARK: - Private Properties
    
    private var userAuthService: UserAuthService
    private let keychainService: KeychainService
    private let localization = LoginLocalization()

    // MARK: - Public Properties
    
    /// URL for Forgot password
    let forgotPasswordURL = URL(string: "https://games.crossfit.com/cf/login?returnTo=%2F&flow=games&ref=login")
    
    // MARK: - Initialization
    
    init() {
        self.init(userAuthService: ServiceFactory.shared.createUserAuthService(),
                  keychainService: ServiceFactory.shared.createKeychainService())
    }

    /// Initalizes Login View Model
    ///
    /// - Parameters:
    ///   - userAuthService: UserAuthService to inject
    ///   - keychainService: KeychainService to inject
    init(userAuthService: UserAuthService, keychainService: KeychainService) {
        self.userAuthService = userAuthService
        self.keychainService = keychainService
    }

    // MARK: - Public Functions
    
    /// Saves the user credentials upon logging in with a checkbox checked for saving the user's email and password.
    ///
    /// - Parameters:
    ///   - email: Email of the user used for login.
    ///   - password: Password of the user used for login.
    func saveCredentials(email: String, password: String) {
        keychainService.set(value: email, for: .username)
        keychainService.set(value: password, for: .password)
    }

    /// Authorizes the user
    ///
    /// - Parameters:
    ///   - email: email of the user
    ///   - password: password of the user
    ///   - completion: completion block which includes an Auth Error if an error exists
    func authorize(withEmail email: String,
                   password: String,
                   completion: @escaping (DetailedUser?, Error?) -> Void) {
        userAuthService.retrieveDetailedUserWithAuth(withEmail: email, password: password, completion: completion)
    }

    /// Validates the email field and updates the error labels
    ///
    /// - Parameter email: email address to be validated
    /// - Returns: a tuple which includes the valid status and the error message if the status is false
    func isValidEmail(email: String?) -> (Bool, String) {
        var isValid = true
        var error: String = ""
        if let email = email {
            /// Validating for empty fields and correct email format
            if email.isEmpty {
                error = localization.errorEmptyUsername
                isValid = false
            } else if !TextValidator.validate(byEmail: email) {
                error = localization.errorInvalidEmail
                isValid = false
            }
        } else {
            isValid = false
        }
        return (isValid, error)
    }

    /// Validates the password field and updates the error labels
    ///
    /// - Parameter password: password to be validated
    /// - Returns: a tuple which includes the valid status and the error message if the status is false
    func isValidPassword(password: String?) -> (Bool, String) {
        var isValid = true
        var error: String = ""

        /// Validate for empty password
        if let password = password {
            if password.isEmpty {
                error = localization.errorEmptyPassword
                isValid = false
            }
        }
        return (isValid, error)
    }

    /// Validates if the login button should enabled or not
    ///
    /// - Parameters:
    ///   - email: email text
    ///   - password: password text
    /// - Returns: valid status
    func validateLoginButton(email: String?, password: String?) -> Bool {
        if !isValidEmail(email: email).0 ||
            !isValidPassword(password: password).0 {
            return false
        }
        return true
    }
}
