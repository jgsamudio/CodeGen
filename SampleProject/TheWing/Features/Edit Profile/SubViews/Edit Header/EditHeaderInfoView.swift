//
//  EditHeaderInfoView.swift
//  TheWing
//
//  Created by Luna An on 4/3/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EditHeaderInfoView: UIView {
    
    // MARK: - Public Properties
    
    /// Edit name view delegate.
    weak var delegate: EditHeaderInfoViewDelegate?

    /// Form field delegate.
    weak var formDelegate: FormDelegate?
    
    lazy var firstNameTextField: UnderlinedFloatLabeledTextField = {
        let placeholder = "FIRST_NAME_REQUIRED".localized(comment: "First Name (required)")
        let title = "FIRST_NAME_REQUIRED".localized(comment: "First Name (required)")
        let textField = UnderlinedFloatLabeledTextField(placeholder: placeholder, floatingTitle: title, theme: theme)
        textField.autocapitalizationType = .words
        textField.delegate = self
        textField.returnKeyType = .done
        textField.textField.placeholderColor = theme.colorTheme.tertiary
        return textField
    }()
    
    lazy var lastNameTextField: UnderlinedFloatLabeledTextField = {
        let placeholder = "LAST_NAME_REQUIRED".localized(comment: "Last Name (required)")
        let title = "LAST_NAME_REQUIRED".localized(comment: "Last Name (required)")
        let textField = UnderlinedFloatLabeledTextField(placeholder: placeholder, floatingTitle: title, theme: theme)
        textField.autocapitalizationType = .words
        textField.delegate = self
        textField.returnKeyType = .done
        textField.textField.placeholderColor = theme.colorTheme.tertiary
        return textField
    }()
    
    // MARK: - Private Properties
    
    private let theme: Theme
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, headlineTextField])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var headlineTextField: UnderlinedFloatLabeledTextField = {
        let placeholder = "ADD_HEADLINE".localized(comment: "Add a headline")
        let title = "HEADLINE".localized(comment: "Headline")
        let textField = UnderlinedFloatLabeledTextField(placeholder: placeholder, floatingTitle: title, theme: theme)
        textField.delegate = self
        textField.returnKeyType = .done
        textField.textField.placeholderColor = theme.colorTheme.tertiary
        return textField
    }()
    
    // MARK: - Initialization
    
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
        
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions

    /// Sets the first and last name of the user.
    ///
    /// - Parameters:
    ///   - firstName: First name to display.
    ///   - lastName: Last name to display.
    ///   - headline: Headline to display.
    func setHeaderFields(firstName: String, lastName: String, headline: String) {
        firstNameTextField.set(firstName.capitalized)
        lastNameTextField.set(lastName.capitalized)
        headlineTextField.set(headline)
    }
    
}

// MARK: - Private Functions
private extension EditHeaderInfoView {
    
    func setupDesign() {
        setupStackView()
    }
    
    func setupStackView() {
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets)
    }
    
}

// MARK: - FormField
extension EditHeaderInfoView: FormField {

    func resignFirstResponder() {
        if firstNameTextField.textField.isFirstResponder {
            firstNameTextField.textField.resignFirstResponder()
        } else if lastNameTextField.textField.isFirstResponder {
            lastNameTextField.textField.resignFirstResponder()
        } else if headlineTextField.textField.isFirstResponder {
            headlineTextField.textField.resignFirstResponder()
        }
    }
    
}

// MARK: - UnderlinedFloatLabeledTextFieldDelegate
extension EditHeaderInfoView: UnderlinedFloatLabeledTextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate?.didEnterField()

        switch textField {
        case firstNameTextField.textField:
            firstNameTextField.activateUnderline()
        case lastNameTextField.textField:
            lastNameTextField.activateUnderline()
        case headlineTextField.textField:
            headlineTextField.activateUnderline()
        default:
            fatalError("Unknown UITextField instance")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextField.textField:
            firstNameTextField.deactivateUnderline()
        case lastNameTextField.textField:
            lastNameTextField.deactivateUnderline()
        case headlineTextField.textField:
            headlineTextField.deactivateUnderline()
        default:
            fatalError("Unknown UITextField instance")
        }
    }
    
    func textFieldEditingChanged(_ textField: UITextField) {
        switch textField {
        case firstNameTextField.textField:
            delegate?.firstNameUpdated(with: textField.text)
        case lastNameTextField.textField:
            delegate?.lastNameUpdated(with: textField.text)
        case headlineTextField.textField:
            delegate?.headlineUpdated(with: textField.text)
        default:
            fatalError("Unknown UITextField instance")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
