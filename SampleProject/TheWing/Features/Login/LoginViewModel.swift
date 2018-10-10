//
//  LoginViewModel.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class LoginViewModel {

    // MARK: - Public Properties
    
    /// User typed email.
    var email: String? {
        didSet {
            validateEmail()
        }
    }

    /// User typed password.
    var password: String? {
        didSet {
            validatePassword()
        }
    }

    /// Binding delegate for the view model.
    weak var delegate: LoginViewDelegate?
    
    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider
    
    private let loginAnalyticsProvider: LoginAnalyticsProvider

    private var isValidEmail: Bool = false {
        didSet {
            if isValidEmail {
                delegate?.isValidEmail(valid: isValidEmail)
            }
            fieldValidationChanged()
        }
    }
    
    private var isValidPassword: Bool = false {
        didSet {
            delegate?.isValidPassword(valid: isValidPassword)
            fieldValidationChanged()
        }
    }
    
    // MARK: - Initialization

    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
        loginAnalyticsProvider = LoginAnalyticsProvider(dependencyProvider: dependencyProvider)
    }

	// MARK: - Public Functions

    // MARK: - Public Functions
    
    /// Logs in the user with the email and password of the view model.
    func loginUser() {
        guard let email = email, let password = password else {
            fatalError("Unreachable login state")
        }
        
        delegate?.isLoading(loading: true)
        dependencyProvider.networkProvider.authLoader.signIn(email: email, password: password) { (result) in
            self.delegate?.isLoading(loading: false)
            if let error = result.error {
                self.delegate?.loginFailed(error: error)
            } else {
                self.delegate?.loginSucceeded()
                self.trackLogin()
            }
        }
    }
    
    /// Indicates user has tapped Contact Us.
    func selectedContactUs() {
        delegate?.emailContactTapped(email: BusinessConstants.contactEmailAddress)
    }
    
    /// Indicates user has tapped Privacy Policy.
    func selectedPrivacyPolicy() {
        if let url = BusinessConstants.privacyPolicyURL {
            delegate?.urlLinkTapped(url: url)
        }
    }
    
    /// Indicates user has tapped Terms and Conditions.
    func selectedTermsAndConditions() {
        if let url = BusinessConstants.termsAndConditionsURL {
            delegate?.urlLinkTapped(url: url)
        }
    }
    
    /// Called when email finished editing.
    func emailDidEndEditing() {
        delegate?.isValidEmail(valid: isValidEmail)
    }
    
    /// Called when password finished editing.
    func passwordDidEndEditing() {
        delegate?.isValidPassword(valid: isValidPassword)
    }
    
    /// Accessibility label for Show/Hide password button.
    ///
    /// - Parameter isPasswordHidden: Whether the password is hidden.
    /// - Returns: Accessibility label.
    func showHidePasswordAccessibilityLabel(isPasswordHidden: Bool) -> String {
        let title = "ACCESSIBILITY_SHOW_HIDE_PASSWORD_LABEL".localized(comment: "Show/Hide Password")
        let statusIs = "ACCESSIBILITY_SHOW_HIDE_PASSWORD_STATUS_IS".localized(comment: "Password is")
        let hidden = "ACCESSIBILITY_SHOW_HIDE_PASSWORD_STATUS_HIDDEN".localized(comment: "hidden")
        let showing = "ACCESSIBILITY_SHOW_HIDE_PASSWORD_STATUS_SHOWING".localized(comment: "showing")
        return "\(title)\(AccessibilityConstants.voiceOverPause) \(statusIs) \(isPasswordHidden ? hidden : showing)"
    }
    
    /// Determines accessibility hint for Login ability from field validation state.
    ///
    /// - Returns: Accessibility hint.
    func validationStateAccessibilityHint() -> String? {
        let instructions = "ACCESSIBILITY_LOGIN_VALIDTION_FAIL_INSTRUCTIONS".localized(comment: "Login validation errors")
        let emailInvalidHint = "ACCESSIBILITY_LOGIN_VALIDATION_EMAIL_INVALID".localized(comment: "Email invalid")
        let passwordInvalidHint = "ACCESSIBILITY_LOGIN_VALIDATION_PASSWORD_INVALID".localized(comment: "Password invalid")
        let email = isValidEmail ? "" : emailInvalidHint
        let password = isValidPassword ? "" : passwordInvalidHint
        
        switch (isValidEmail, isValidPassword) {
        case (true, true):
            return nil
        case (false, false):
            let voiceOverPause = AccessibilityConstants.voiceOverPause
            return "\(instructions) \(voiceOverPause) \(email) \(voiceOverPause) \(password)"
        case (true, false):
            return "\(instructions) \(AccessibilityConstants.voiceOverPause) \(password)"
        case (false, true):
            return "\(instructions) \(AccessibilityConstants.voiceOverPause) \(email)"
        }
    }
    
    /// Called when Forgot Password button is selected.
    @objc func forgotPasswordSelected() {
        if let url = BusinessConstants.forgotPasswordURL {
            delegate?.urlLinkTapped(url: url)
        }
    }

}

// MARK: - Private Functions
private extension LoginViewModel {
    
    func validateEmail() {
        guard let email = email else {
            isValidEmail = false
            return
        }
        
        isValidEmail = email.isValidEmail
    }

    func validatePassword() {
        guard let password = password else {
            isValidPassword = false
            return
        }
        
        isValidPassword = password.isValidPassword
    }
    
    func fieldValidationChanged() {
        let enableLogin = isValidEmail && isValidPassword
        delegate?.isLoginValid(valid: enableLogin)
    }
    
    func trackLogin() {
        loginAnalyticsProvider.captureScreenInformation()
        loginAnalyticsProvider.identifyUserTraits()
        loginAnalyticsProvider.trackLoginEvent()
    }
    
}
