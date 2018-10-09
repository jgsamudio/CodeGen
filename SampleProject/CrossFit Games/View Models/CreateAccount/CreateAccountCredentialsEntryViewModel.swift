//
//  CreateAccountCredentialsEntryViewModel.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/2/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// The view model for the CreateAccountCredentialsEntry, which communicates with the
/// service layer
struct CreateAccountCredentialsEntryViewModel {

    private var createAccountService: CreateAccountService
    private var userAuthService: UserAuthService
    private let localization = CreateAccountCredentialsEntryLocalization()

    init() {
        createAccountService = ServiceFactory.shared.createAccountService()
        userAuthService = ServiceFactory.shared.createUserAuthService()
    }

    /// Validates the email text and returns the valid status with the relevant error message as a string
    ///
    /// - Parameter email: email to be validated
    /// - Returns: a tuple which includes the valid status and the error message if the status is false
    func isValidEmail(email: String?) -> (Bool, String) {
        var isValid = true
        var error: String = ""
        if let email = email {
            /// Validating for empty fields and correct email format
            if email.isEmpty {
                error = localization.errorEmptyEmail
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

    /// Validates if the next button should enabled or not
    ///
    /// - Parameters:
    ///   - email: email text
    ///   - password: password text
    /// - Returns: valid status
    func validateNextButton(email: String?, password: String?) -> Bool {
        if !isValidEmail(email: email).0 ||
            !isValidPassword(password: password).0 {
            return false
        }
        return true
    }

    /// Creates user account
    ///
    /// - Parameters:
    ///   - email: email of the user
    ///   - password: password of the user
    ///   - completion: completion block which includes the error if occurred
    func createUserAccount(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        if let user = createAccountService.readUserFromLocalStore(),
            let firstName = user.firstName,
            let lastName = user.lastName {
            createAccountService.createUserAccount(withEmail: email,
                                                        password: password,
                                                        firstName: firstName,
                                                        lastName: lastName,
                                                        completion: { (error) in
                completion(error)
            })
        }
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
}
