//
//  UnderlinedFloatLabeledTextFieldDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Delegate for underlined float labeled text field view.
protocol UnderlinedFloatLabeledTextFieldDelegate: class, UITextFieldDelegate {

    /// Called whrn the text field is finished editing.
    ///
    /// - Parameter textField: Current text field.
    func textFieldEditingChanged(_ textField: UITextField)

    /// Called when the accessory button is selected.
    func accessoryButtonSelected()
    
}

extension UnderlinedFloatLabeledTextFieldDelegate {
    
    // MARK: - Public Functions
    
    func textFieldEditingChanged(_ textField: UITextField) {
        // This is optional
    }
    
    func accessoryButtonSelected() {
        // This is optional
    }
    
}
