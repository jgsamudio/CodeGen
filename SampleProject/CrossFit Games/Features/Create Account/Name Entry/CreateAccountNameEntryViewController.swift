//
//  CreateAccountNameEntryViewController.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/2/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Simcoe
import UIKit

final class CreateAccountNameEntryViewController: BaseAuthViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var firstNameTextField: StyleableTextField!
    @IBOutlet private weak var lastNameTextField: StyleableTextField!
    @IBOutlet private weak var firstNameErrorLabel: StyleableErrorLabel!
    @IBOutlet private weak var lastNameErrorLabel: StyleableErrorLabel!
    @IBOutlet private weak var lastNameLabel: StyleableLabel!
    @IBOutlet private weak var firstNameLabel: StyleableLabel!
    @IBOutlet private weak var nextButton: StyleableButton!
    @IBOutlet private weak var agreementlabel: TappableLabel!
    @IBOutlet private weak var stepLabel: StyleableLabel!

    var viewModel: CreateAccountNameEntryViewModel!

    let localization = CreateAccountNameEntryLocalization()
    let generalLocalization = GeneralLocalization()

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUserValues()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParentViewController {
            Simcoe.track(event: .createAccountExit,
                         withAdditionalProperties: [:], on: .createAccount)
            clearUserValues()
        }
    }

    @IBAction private func firstNameDidChange(_ sender: UITextField) {
        if viewModel.isValidFirstName(firstName: firstNameTextField.text).0 {
            firstNameTextField.addRightView()
        } else {
            firstNameTextField.removeRightView()
        }
        validateNextButton()
    }

    @IBAction private func lastNameDidChange(_ sender: UITextField) {
        if viewModel.isValidLastName(lastName: lastNameTextField.text).0 {
            lastNameTextField.addRightView()
        } else {
            lastNameTextField.removeRightView()
        }
        validateNextButton()
    }

    @IBAction private func didTapNext(_ sender: StyleableButton) {
        isValidToProceed()
    }

    // MARK: - General functions
    private func config() {
        title = localization.title
        stepLabel.text = localization.step
        firstNameLabel.text = localization.firstName
        lastNameLabel.text = localization.lastName

        firstNameTextField.addBottomBorder()
        lastNameTextField.addBottomBorder()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self

        nextButton.backgroundColor = .white

        agreementlabel.text = localization.tappableText
        agreementlabel.tappableStrings = [localization.termsOfService, localization.privacyPolicy]
        agreementlabel.delegate = self

        let tapGestureSelector = #selector(CreateAccountNameEntryViewController.didTapBackground)
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                        action: tapGestureSelector)
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.enableKeyboardOffset()
    }

    private func clearErrorLabels() {
        firstNameErrorLabel.clearError()
        firstNameTextField.addBottomBorder()
        lastNameErrorLabel.clearError()
        lastNameTextField.addBottomBorder()
    }

    private func showFirstNameError(error: String) {
        firstNameErrorLabel.showError(error: error)
        firstNameTextField.addBottomBorder(color: StyleColumn.c3.color)
    }

    private func showLastNameError(error: String) {
        lastNameErrorLabel.showError(error: error)
        lastNameTextField.addBottomBorder(color: StyleColumn.c3.color)
    }

    /// Validates the next button
    /// If either of the fields are empty the next button should be disabled
    private func validateNextButton() {
        nextButton.isEnabled = viewModel.validateNextButton(firstName: firstNameTextField.text,
                                                            lastName: lastNameTextField.text)
        nextButton.applyStyle()
    }

    @discardableResult
    private func isValidToProceed() -> Bool {
        if let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text {
            let firstNameValidationResult = viewModel.isValidFirstName(firstName: firstName)
            let lastNameValidationResult = viewModel.isValidLastName(lastName: lastName)
            if firstNameValidationResult.0 &&
                lastNameValidationResult.0 {
                viewModel.saveUser(withFirstName: firstName, lastName: lastName)
                navigateToCredentialsScreen()
            } else {
                if !firstNameValidationResult.0 {
                    showFirstNameError(error: firstNameValidationResult.1)
                }
                if !lastNameValidationResult.0 {
                    showLastNameError(error: lastNameValidationResult.1)
                }
                return false
            }
        }
        return true
    }

    @objc private func didTapBackground() {
        view.endEditing(true)
    }

    private func setUserValues() {
        if let user = viewModel.readUser() {
            firstNameTextField.text = user.firstName
            lastNameTextField.text = user.lastName
        }
        validateNextButton()
    }

    private func clearUserValues() {
        viewModel.removeUser()
    }

    private func navigateToCredentialsScreen() {
        let createAccountCredentialsEntryViewController = CreateAccountCredentialsEntryBuilder().build()

        /// Adding the back button will be modified once the designs are finalized
        navigationController?.pushViewController(createAccountCredentialsEntryViewController, animated: true)
    }

}

// MARK: - UITextFieldDelegate
extension CreateAccountNameEntryViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == firstNameTextField {
            let validationResult = viewModel.isValidFirstName(firstName: textField.text)
            if validationResult.0 {
                lastNameTextField.becomeFirstResponder()
            } else {
                showFirstNameError(error: validationResult.1)
                return false
            }
        } else if textField == lastNameTextField {
            return isValidToProceed()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearErrorLabels()
    }

}

// MARK: - TappableLabelDelegate
extension CreateAccountNameEntryViewController: TappableLabelDelegate {

    func tappableLabel(_ label: TappableLabel, didTapLinkAtIndex index: Int, withContent content: String) {
        if label == agreementlabel && index == 0 {
            if let termsOfServiceURL = URL(string: viewModel.termsAndConditionsURL) {
                UIApplication.shared.open(termsOfServiceURL, options: [:], completionHandler: nil)
            }
        } else if label == agreementlabel && index == 1 {
            if let privacyPolicyURL = URL(string: viewModel.privacyPolicyURL) {
                UIApplication.shared.open(privacyPolicyURL, options: [:], completionHandler: nil)
            }
        }
    }
}
