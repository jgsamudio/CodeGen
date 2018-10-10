//
//  GuestFormView.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class GuestFormView: BuildableView {

    // MARK: - Public Properties

    /// Delegate.
    weak var delegate: GuestFormViewDelegate?
    
    // MARK: - Private Properties
    
    private lazy var formFields: [GuestFormRow: UnderlinedFloatLabeledTextField] = [.firstName: firstNameField,
                                                                                    .lastName: lastNameField,
                                                                                    .email: emailField]
    
    private lazy var titleLabel = UILabel()
    
    private lazy var firstNameField: UnderlinedFloatLabeledTextField = {
        let placeholder = "FIRST_NAME_REQUIRED".localized(comment: "First Name (required)")
        let textField = UnderlinedFloatLabeledTextField(placeholder: placeholder, theme: theme)
        textField.autocapitalizationType = .words
        textField.delegate = self
        return textField
    }()
    
    private lazy var lastNameField: UnderlinedFloatLabeledTextField = {
        let placeholder = "LAST_NAME_REQUIRED".localized(comment: "Last Name (required)")
        let textField = UnderlinedFloatLabeledTextField(placeholder: placeholder, theme: theme)
        textField.autocapitalizationType = .words
        textField.delegate = self
        return textField
    }()
    
    private lazy var emailField: UnderlinedFloatLabeledTextField = {
        let placeholder = "EMAIL_REQUIRED".localized(comment: "Email (required)")
        let textField = UnderlinedFloatLabeledTextField(placeholder: placeholder, theme: theme)
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.delegate = self
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstNameField, lastNameField, emailField])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    
    /// Shows an inline error message in given field.
    ///
    /// - Parameters:
    ///   - row: Field row.
    ///   - message: Error message.
    func showError(in row: GuestFormRow, message: String) {
        formFields[row]?.showError(message)
    }
    
    /// Hides error message in given field.
    ///
    /// - Parameter row: Field row.
    func hideError(in row: GuestFormRow) {
        formFields[row]?.hideError()
    }
    
    /// Returns text in textfield at given row.
    ///
    /// - Parameter row: Row key.
    /// - Returns: Optional string.
    func text(in row: GuestFormRow) -> String? {
        return formFields[row]?.textField.text
    }

}

// MARK: - Private Functions
private extension GuestFormView {
    
    func setupDesign() {
        titleLabel.setText("GUEST".localized(comment: "Guest"), using: theme.textStyleTheme.headline3)
        addSubview(titleLabel)
        titleLabel.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets, excludingEdge: .bottom)
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets, excludingEdge: .top)
        stackView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 11)
    }
    
}

// MARK: - UnderlinedFloatLabeledTextFieldDelegate
extension GuestFormView: UnderlinedFloatLabeledTextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formFields.forEach {
            if $0.value.textField == textField {
                $0.value.activateUnderline()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        formFields.forEach {
            if $0.value.textField == textField {
                $0.value.deactivateUnderline()
                delegate?.fieldDidEndEditing(self, at: $0.key)
            }
        }
    }
    
    func textFieldEditingChanged(_ textField: UITextField) {
        formFields.forEach {
            if $0.value.textField == textField {
                delegate?.fieldEditingDidChange(self, at: $0.key)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
