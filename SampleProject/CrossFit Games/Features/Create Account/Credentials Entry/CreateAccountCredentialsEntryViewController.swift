//
//  CreateAccountCredentialsEntryViewController.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/2/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Simcoe
import UIKit
// swiftlint:disable type_name
final class CreateAccountCredentialsEntryViewController: BaseAuthViewController {

    @IBOutlet private weak var passwordLabel: StyleableLabel!
    @IBOutlet private weak var emailLabel: StyleableLabel!
    @IBOutlet private weak var emailTextField: StyleableTextField!
    @IBOutlet private weak var passwordTextField: StyleableTextField!
    @IBOutlet private weak var emailErrorLabel: StyleableErrorLabel!
    @IBOutlet private weak var passwordErrorLabel: StyleableErrorLabel!
    @IBOutlet private weak var doneButton: StyleableButton!
    @IBOutlet private weak var stepLabel: StyleableLabel!
    @IBOutlet private weak var rememberMeButton: CheckmarkButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var signInLabel: TappableLabel!
    private var errorView: FullscreenErrorView!

    var viewModel: CreateAccountCredentialsEntryViewModel!

    private let localization = CreateAccountCredentialsEntryLocalization()
    private let loginLocalization = LoginLocalization()
    private let generalLocalization = GeneralLocalization()

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateNextButton()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction private func emailDidChange(_ sender: StyleableTextField) {
        if viewModel.isValidEmail(email: emailTextField.text).0 {
            emailTextField.addRightView()
        } else {
            emailTextField.removeRightView()
        }
        validateNextButton()
    }

    @IBAction private func passwordDidChange(_ sender: StyleableTextField) {
        if viewModel.isValidPassword(password: passwordTextField.text).0 {
            passwordTextField.addRightView()
        } else {
            passwordTextField.removeRightView()
        }
        validateNextButton()
    }

    @IBAction private func didTapDone(_ sender: StyleableButton) {
        createAccount()
    }

    // MARK: - General functions

    private func config() {
        title = localization.title
        stepLabel.text = localization.step
        emailLabel.text = localization.email
        passwordLabel.text = localization.password
        signInLabel.text = localization.tappableText
        signInLabel.tappableStrings = [localization.signIn]

        doneButton.setTitle(localization.done, for: .normal)
        doneButton.setTitle(localization.done, for: .disabled)
        emailTextField.addBottomBorder()
        passwordTextField.addBottomBorder()
        doneButton.backgroundColor = .white
        rememberMeButton.isChecked = true

        emailTextField.becomeFirstResponder()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        signInLabel.delegate = self

        let tapGestureSelector = #selector(CreateAccountCredentialsEntryViewController.didTapBackground)
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                        action: tapGestureSelector)
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.enableKeyboardOffset()
    }

    /// Clears error labels
    private func clearErrorLabels() {
        passwordTextField.addBottomBorder()
        emailTextField.addBottomBorder()
        passwordErrorLabel.clearError()
        emailErrorLabel.clearError()
    }

    /// Validates the next button
    /// If either of the fields are empty the next button should be disabled
    private func validateNextButton() {
        doneButton.isEnabled = viewModel.validateNextButton(email: emailTextField.text,
                                                            password: passwordTextField.text)
        doneButton.applyStyle()
    }

    /// Performs creating the account
    /// Validates email and password fields before performing the actions
    ///
    /// - Parameters:
    ///   - isRetryAttempt: if it is a retry attempt
    ///   - completion: completion block
    private func createAccount(isRetryAttempt: Bool = false, completion: @escaping (Error?) -> Void = { _ in }) {
        if let email = emailTextField.text,
            let password = passwordTextField.text {

            /// Validate email and password fields
            let emailValidationResult = viewModel.isValidEmail(email: email)
            let passwordValidationResult = viewModel.isValidPassword(password: password)

            /// Perform authorizing action if no field error exist
            if emailValidationResult.0 && passwordValidationResult.0 {
                doneButton.showLoading(withColor: UIColor.black)
                viewModel.createUserAccount(withEmail: email,
                                            password: password,
                                            completion: { [weak self] error in
                                                guard let wself = self else {
                                                    return
                                                }

                                                wself.doneButton.hideLoading()

                                                if let error = error {
                                                    switch error {
                                                    case AuthError.accountExists:
                                                        wself.showAlertView(title: wself.localization.errorAccountExistsTitle,
                                                                            subtitle: wself.localization.errorAccountExistsSubtitle)
                                                        if let cover = wself.errorView {
                                                            cover.removeFromSuperview()
                                                        }
                                                    case APIError.forceUpdate(title: let title, message: let message, storeLink: let storeLink):
                                                        KillSwitchManager.showForceUpdateAlert(title: title, message: message, storeLink: storeLink)
                                                    case APIError.inactive(title: let title, message: let message):
                                                        FullscreenErrorView.presentWindow(
                                                            title: title,
                                                            message: message,
                                                            onTap: { [weak self] retry in
                                                                self?.createAccount(isRetryAttempt: true, completion: retry)
                                                        })
                                                    default:
                                                        if isRetryAttempt {
                                                            completion(error)
                                                        } else {
                                                            wself.errorView = FullscreenErrorView.cover(wself.view, onTap: { retryCompletion in
                                                                wself.createAccount(isRetryAttempt: true, completion: retryCompletion)
                                                            })
                                                        }
                                                    }
                                                } else {
                                                    wself.signIn()
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

    /// Performs sign in action
    /// Validates email and password fields before performing the actions
    /// - Parameters:
    ///   - isRetryAttempt: if it is a retry attempt
    ///   - completion: completion block
    private func signIn(isRetryAttempt: Bool = false, completion: @escaping (Error?) -> Void = { _ in }) {
        Simcoe.track(event: .createAccountSuccess,
                     withAdditionalProperties: [:], on: .createAccount)
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            
            doneButton.showLoading(withColor: UIColor.black)
            viewModel.authorize(withEmail: email, password: password, completion: { [weak self] (_, error) in
                guard let wself = self else {
                    return
                }

                wself.doneButton.hideLoading()

                if let error = error {
                    switch error {
                    case AuthError.credentialsInvalid:
                        let bannerText = wself.loginLocalization.errorInvalidCredentials
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
                    /// Navigate to the home screen
                    UIView.fadePresentedViewController(to: MainNavigationBuilder().build())
                }
            })
        }
    }

    private func showAlertView(title: String, subtitle: String) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: localization.promptCancel, style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: localization.promptLogin, style: .default, handler: { action in
            switch action.style {
            case .default:
                self.navigateToSignIn()
            default:
                break
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func navigateToSignIn() {
        if let loginViewController = LoginBuilder().build() as? LoginViewController,
            let email = emailTextField.text {
            loginViewController.userEmail = email
            navigationController?.pushViewController(loginViewController, animated: true)
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

    @objc private func didTapBackground() {
        view.endEditing(true)
    }

}

// MARK: - UITextFieldDelegate
extension CreateAccountCredentialsEntryViewController: UITextFieldDelegate {

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
            createAccount()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearErrorLabels()
    }
    
}

// MARK: - TappableLabelDelegate
extension CreateAccountCredentialsEntryViewController: TappableLabelDelegate {

    func tappableLabel(_ label: TappableLabel, didTapLinkAtIndex index: Int, withContent content: String) {
        if label == signInLabel {
            let loginViewController = LoginBuilder().build()
            navigationController?.pushViewController(loginViewController, animated: true)
        }
    }

}
