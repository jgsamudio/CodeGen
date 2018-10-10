//
//  EditEmptyOccupationView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EditEmptyOccupationView: UIView {

    // MARK: - Public Properties

    weak var delegate: EditEmptyOccupationDelegate?

    // MARK: - Private Properties

    private lazy var occupationTextField: UnderlinedFloatLabeledTextField = {
        let textField = UnderlinedFloatLabeledTextField(placeholder: "Add Your Occupation",
                                                        floatingTitle: nil,
                                                        theme: theme)
        textField.isUserInteractionEnabled = false
        textField.textField.placeholderColor = theme.colorTheme.tertiary
        return textField
    }()

    private let theme: Theme

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
    
    /// Hides error message of the occupation text field.
    func hideError() {
        occupationTextField.hideError()
    }
    
    /// Shows error message of the occupation text field.
    func showError(_ message: String) {
        occupationTextField.showError(message)
    }

}

// MARK: - Private Functions
private extension EditEmptyOccupationView {

    func setupDesign() {
        addSubview(occupationTextField)

        let gutter = ViewConstants.defaultGutter
        let insets = UIEdgeInsets(top: 0, left: gutter, bottom: 0, right: gutter)
        occupationTextField.autoPinEdgesToSuperviewEdges(with: insets)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTextField))
        addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func didTapTextField() {
        delegate?.addOccupationSelected()
    }

}
