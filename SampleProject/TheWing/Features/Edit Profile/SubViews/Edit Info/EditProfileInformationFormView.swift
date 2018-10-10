//
//  EditProfileInformationFormView.swift
//  TheWing
//
//  Created by Luna An on 7/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EditProfileInformationFormView: BuildableView {
    
    // MARK: - Public Properties
    
    /// Edit profile information form view delegate.
    weak var delegate: EditProfileInformationFormViewDelegate?
    
    /// Form field delegate.
    weak var formDelegate: FormDelegate?
    
    /// Auto capitalization type.
    var autocapitalizationType: UITextAutocapitalizationType {
        get {
            return floatingTextField.autocapitalizationType
        } set {
            floatingTextField.autocapitalizationType = newValue
        }
    }
    
    /// Keyboard type.
    var keyboardType: UIKeyboardType {
        get {
            return floatingTextField.keyboardType
        } set {
            floatingTextField.keyboardType = newValue
        }
    }

    /// Keyboard return type.
    var returnType: UIReturnKeyType {
        get {
            return floatingTextField.returnKeyType
        } set {
            floatingTextField.returnKeyType = newValue
        }
    }
    
    // MARK: - Private Properties
    
    private var type: EditProfileInformationFormViewType
    
    private let floatingTextField: UnderlinedFloatLabeledTextField
    
    // MARK: - Initialization
    
    init(placeHolder: String?, title: String?, type: EditProfileInformationFormViewType, theme: Theme) {
        floatingTextField = UnderlinedFloatLabeledTextField(placeholder: placeHolder, floatingTitle: title, theme: theme)
        floatingTextField.textField.placeholderColor = theme.colorTheme.tertiary
        self.type = type
        super.init(theme: theme)
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets the textfield text.
    ///
    /// - Parameter text: Text
    func setInformation(_ text: String?) {
        floatingTextField.set(text)
    }
    
    /// Hides error message of the floating text field.
    func hideError() {
        floatingTextField.hideError()
    }
    
    /// Shows error message of the floating text field.
    func showError(_ message: String) {
        floatingTextField.showError(message)
    }
    
    /// Disables user interaction of the text field.
    func disableTextField() {
        floatingTextField.isUserInteractionEnabled = false
    }
    
}

// MARK: - Private Functions
private extension EditProfileInformationFormView {
    
    func setupTextField() {
        addSubview(floatingTextField)
        floatingTextField.delegate = self
        floatingTextField.returnKeyType = .done
        positionTextField()
    }
    
    func positionTextField() {
        let insets = UIEdgeInsets(top: 0, left: ViewConstants.defaultGutter, bottom: 0, right: ViewConstants.defaultGutter)
        floatingTextField.autoPinEdgesToSuperviewEdges(with: insets)
    }
    
}

// MARK: - UnderlinedFloatLabeledTextFieldDelegate
extension EditProfileInformationFormView: UnderlinedFloatLabeledTextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return floatingTextField.isUserInteractionEnabled
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate?.didEnterField()
        floatingTextField.activateUnderline()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        floatingTextField.deactivateUnderline()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldEditingChanged(_ textField: UITextField) {
        switch type {
        case .neighborhood:
            delegate?.neighborhoodUpdated(textField.text)
        case .email:
            delegate?.emailUpdated(textField.text)
        }
    }
    
}

// MARK: - FormField
extension EditProfileInformationFormView: FormField {
    
    func resignFirstResponder() {
        if floatingTextField.textField.isFirstResponder {
            floatingTextField.resignFirstResponder()
        }
    }
    
}
