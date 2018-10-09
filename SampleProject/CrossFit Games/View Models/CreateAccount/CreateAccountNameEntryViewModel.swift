//
//  CreateAccountViewModel.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/20/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// The view model for the CreateAccountNameEntry, which communicates with the
/// service layer
struct CreateAccountNameEntryViewModel {

    // MARK: - Private Properties
    
    private var createAccountService: CreateAccountService
    private let localization = CreateAccountNameEntryLocalization()

    // MARK: - Public Properties
    
    /// URL for the terms and conditions web page
    var termsAndConditionsURL: String {
        return "https://www.crossfit.com/cf/terms-and-conditions"
    }

    /// URL for the privacy policy web page
    var privacyPolicyURL: String {
        return "https://www.crossfit.com/cf/privacy"
    }
    
    // MARK: - Initialization
    
    init() {
        createAccountService = ServiceFactory.shared.createAccountService()
    }

    // MARK: - Public Functions
    
    /// Validates the first name field and updates the error labels
    ///
    /// - Parameter firstName: first name to be validated
    /// - Returns: a tuple which includes the valid status and the error message if the status is false
    func isValidFirstName(firstName: String?) -> (Bool, String) {
        var isValid = true
        var error: String = ""
        if let firstName = firstName {
            /// Validating for empty first name
            if firstName.isEmpty {
                error = localization.errorEmptyFirstName
                isValid = false
            }
        } else {
            isValid = false
        }
        return (isValid, error)
    }

    /// Validates the last name field and updates the error labels
    ///
    /// - Parameter lastName: last name to be validated
    /// - Returns: Returns: a tuple which includes the valid status and the error message if the status is false
    func isValidLastName(lastName: String?) -> (Bool, String) {
        var isValid = true
        var error: String = ""

        /// Validate for empty last name
        if let lastName = lastName {
            if lastName.isEmpty {
                error = localization.errorEmptyLastName
                isValid = false
            }
        }
        return (isValid, error)
    }

    /// Validates if the next button should enabled or not
    ///
    /// - Parameters:
    ///   - firstName: first name to be validated
    ///   - lastName: last name to be validated
    /// - Returns: valid status
    func validateNextButton(firstName: String?, lastName: String?) -> Bool {
        if !isValidFirstName(firstName: firstName).0 ||
            !isValidLastName(lastName: lastName).0 {
            return false
        }
        return true
    }

    /// Saves user in localstore
    ///
    /// - Parameters:
    ///   - firstName: first name of the user
    ///   - lastName: last name of the user
    func saveUser(withFirstName firstName: String,
                  lastName: String) {
        createAccountService.saveUserInLocalStore(withFirstName: firstName, lastName: lastName, email: nil)
    }

    /// Reads locally saved user
    ///
    /// - Returns: locally saved user
    func readUser() -> User? {
        return createAccountService.readUserFromLocalStore()
    }

    /// Removes the locally saved user by setting all the fields to nil
    func removeUser() {
        createAccountService.removeUserFromLocalStore()
    }

}
