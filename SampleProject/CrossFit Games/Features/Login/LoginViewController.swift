//
//  LoginViewController.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/26/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Simcoe
import UIKit

final class LoginViewController: BaseAuthViewController {

    // MARK: - Private Properties
    
    @IBOutlet private weak var emailLabel: StyleableLabel!
    @IBOutlet private weak var passwordLabel: StyleableLabel!
    @IBOutlet private weak var loginButton: StyleableButton!
    @IBOutlet private weak var emailTextField: StyleableTextField!
    @IBOutlet private weak var passwordTextField: StyleableTextField!
    @IBOutlet private weak var passwordErrorLabel: StyleableErrorLabel!
    @IBOutlet private weak var emailErrorLabel: StyleableErrorLabel!
    @IBOutlet private weak var forgotPasswordButton: StyleableButton!
    @IBOutlet private weak var rememberMeLabel: StyleableLabel!
    @IBOutlet private weak var rememberMeCheckmarkButton: CheckmarkButton!

    @IBOutlet private weak var scrollView: UIScrollView!
    private let localization = LoginLocalization()
    private let generalLocalization = GeneralLocalization()

    // MARK: - Public Properties
    
    /// Completion block that is called once the user finished the login flow.
    var loginCompletion: ((LoginEvent) -> Void)?

    var viewModel: LoginViewModel!
    /// to set user email when navigated from the create account screen
    var userEmail: String?

    private var keyboardMoveUpDifference: CGFloat!
    private var hasKeyboardMovedUp: Bool = false
    private var errorView: FullscreenErrorView!

    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        if loginCompletion == nil {
            loginCompletion = { result in
                switch result {
                case .loginSucceeded:
                    UIView.fadePresentedViewController(to: MainNavigationBuilder().build())
                case .loginCancelled:
                    break
                }
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUserEmail()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParentViewController {
            loginCompletion?(.loginCancelled)
            Simcoe.track(event: .signInExit,
                         withAdditionalProperties: [:], on: .signIn)
        }
    }

    // MARK: - Action functions
    @IBAction private func didTapSignIn(_ sender: UIButton) {
        signIn()
    }

    @IBAction private func emailDidChangeEditing(_ sender: StyleableTextField) {
        emailTextField.text = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if viewModel.isValidEmail(email: emailTextField.text).0 {
            emailTextField.addRightView()
        } else {
            emailTextField.removeRightView()
        }
        validateLoginButton()
    }

    @IBAction private func didTapForgotPassword(_ sender: StyleableButton) {
        Simcoe.track(event: .forgotPassword,
                     withAdditionalProperties: [:], on: .signIn)
        if let url = viewModel.forgotPasswordURL {
            let safariViewController = SFSafariBuilder(url: url).build()
            safariViewController.modalPresentationStyle = .overFullScreen
            present(safariViewController, animated: true)
        }
    }
    
    @IBAction private func passwordDidChangeEditing(_ sender: StyleableTextField) {
        if viewModel.isValidPassword(password: passwordTextField.text).0 {
            passwordTextField.addRightView()
        } else {
            passwordTextField.removeRightView()
        }
        validateLoginButton()
    }

    // MARK: - General functions

    private func setUserEmail() {
        if let email = userEmail {
            emailTextField.text = email
        }
    }

    private func config() {
        scrollView.enableKeyboardOffset()
        emailTextField.becomeFirstResponder()
        emailTextField.addBottomBorder()
        passwordTextField.addBottomBorder()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.backgroundColor = .white

        emailLabel.text = localization.email
        passwordLabel.text = localization.password
        rememberMeLabel.text = localization.rememberMe
        forgotPasswordButton.setTitle(localization.forgotPassword, for: .normal)
        loginButton.setTitle(localization.loginButton, for: .normal)
        loginButton.setTitle(localization.loginButton, for: .disabled)

        validateLoginButton()
        rememberMeCheckmarkButton.isChecked = true

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.didTapBackground))
        scrollView.addGestureRecognizer(tapGesture)
    }

    /// Clears error labels
    private func clearErrorLabels() {
        passwordErrorLabel.clearError()
        passwordTextField.addBottomBorder()
        emailErrorLabel.clearError()
        emailTextField.addBottomBorder()
    }

    /// Validates the log in button
    /// If either of the fields are empty the next button should be disabled
    private func validateLoginButton() {
        loginButton.isEnabled = viewModel.validateLoginButton(email: emailTextField.text,
                                                            password: passwordTextField.text)
        loginButton.applyStyle()
    }

    @objc private func didTapBackground() {
        view.endEditing(true)
    }

    /// Performs sign in action
    /// Validates email and password fields before performing the actions
    /// - Parameters:
    ///   - isRetryAttempt: if it is a retry attempt
    ///   - completion: completion block
    private func signIn(isRetryAttempt: Bool = false, completion: @escaping (Error?) -> Void = { _ in }) {
        if let email = emailTextField.text,
            let password = passwordTextField.text {

            /// Validate email and password fields
            let emailValidationResult = viewModel.isValidEmail(email: email)
            let passwordValidationResult = viewModel.isValidPassword(password: password)

            /// Perform authorizing action if no field error exist
            if emailValidationResult.0 && passwordValidationResult.0 {
                loginButton.showLoading(withColor: UIColor.black)
                viewModel.authorize(withEmail: email, password: password, completion: { [weak self] (_, error) in
                    guard let wself = self else {
                        return
                    }

                    wself.loginButton.hideLoading()

                    if let error = error {
                        switch error {
                        case AuthError.credentialsInvalid:
                            let bannerText = wself.localization.errorInvalidCredentials
                            BannerManager.showBanner(text: bannerText)
                            KillSwitchManager.hideWindow()
                            if let cover = wself.errorView {
                                cover.removeFromSuperview()
                            }
                        case APIError.forceUpdate(title: let title, message: let message, storeLink: let storeLink):
                            KillSwitchManager.hideWindow()
                            KillSwitchManager.showForceUpdateAlert(title: title, message: message, storeLink: storeLink)
                        case APIError.inactive(title: let title, message: let message):
                            FullscreenErrorView.presentWindow(title: title, message: message, onTap: { [weak self] retry in
                                self?.signIn(isRetryAttempt: true, completion: retry)
                            })
                        default:
                            if isRetryAttempt {
                                completion(error)
                            } else {
                                wself.errorView = FullscreenErrorView.cover(wself.view, onTap: { retryCompletion in
                                    wself.signIn(isRetryAttempt: true, completion: retryCompletion)
                                })
                            }
                        }
                    } else {
                        KillSwitchManager.hideWindow()
                        Simcoe.track(event: .signInSuccess,
                                     withAdditionalProperties: [:], on: .signIn)

                        /// Navigate to the home screen
                        if self?.rememberMeCheckmarkButton.isChecked ?? false {
                            self?.viewModel.saveCredentials(email: email, password: password)
                        }

                        self?.loginCompletion?(.loginSucceeded)
                    }
                })
            } else {
                if !emailValidationResult.0 {
                    showEmailError(error: emailValidationResult.1)
                }
                if !passwordValidationResult.0 {
                    showPasswordError(error: passwordValidationResult.1)
                }
            }
        }
    }

    private func showEmailError(error: String) {
        emailErrorLabel.showError(error: error)
        emailTextField.addBottomBorder(color: StyleColumn.c3.color)
    }

    private func showPasswordError(error: String) {
        passwordErrorLabel.showError(error: error)
        passwordTextField.addBottomBorder(color: StyleColumn.c3.color)
    }

}

/// Includes textfield delegate functions
// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTextField {
            let validationResult = viewModel.isValidEmail(email: textField.text)
            if validationResult.0 {
                passwordTextField.becomeFirstResponder()
            } else {
                showEmailError(error: validationResult.1)
                return false
            }
        } else if textField == passwordTextField {
            signIn()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearErrorLabels()
    }

}
