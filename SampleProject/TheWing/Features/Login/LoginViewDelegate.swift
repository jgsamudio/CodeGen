//
//  LoginViewDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol LoginViewDelegate: class {

    /// Called when login call succeeds.
    func loginSucceeded()

    /// Called when login call fails.
    ///
    /// - Parameter error: Error of the failed request.
    func loginFailed(error: Error)
    
    /// Indicates user tapped the contact via email button.
    func emailContactTapped(email: String)

    /// Indicates user tapped the privacy policy button.
    func urlLinkTapped(url: URL)

    /// Indicates if email entry is valid.
    ///
    /// - Parameter valid: Valid.
    func isValidEmail(valid: Bool)

    /// Indicates if password entry is valid.
    ///
    /// - Parameter valid: Valid.
    func isValidPassword(valid: Bool)

    /// Indicates if login fields are valid.
    ///
    /// - Parameter valid: Valid.
    func isLoginValid(valid: Bool)

    /// Called when the loading state changes.
    ///
    /// - Parameter loading: Determines if there is a network call loading.
    func isLoading(loading: Bool)

}
