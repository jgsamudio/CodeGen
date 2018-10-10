//
//  TextFieldPickerDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol TextFieldPickerDelegate: class {

    /// Called when the text field is selected.
    ///
    /// - Parameter textFieldPicker: Current TextFieldPicker.
    func didSelectField(textFieldPicker: TextFieldPicker)

    /// Called when an item is selected in the picker.
    ///
    /// - Parameters:
    ///   - item: Picker item selected.
    ///   - textFieldPicker: Current TextFieldPicker.
    func didSelectPickerItem(item: String, textFieldPicker: TextFieldPicker)
    
    /// Called when two items are selected in the picker with two components.
    ///
    /// - Parameters:
    ///   - firstItem: Picker item index selected from the first component.
    ///   - secondItem: Picker item  index selected from the second component.
    ///   - textFieldPicker: Current TextFieldPicker.
    func didSelectPickerItems(firstItem: Int, secondItem: Int, textFieldPicker: TextFieldPicker)

    /// Called when the done button is selected on the picker.
    ///
    /// - Parameter textFieldPicker: Current TextFieldPicker.
    func didSelectDone(textFieldPicker: TextFieldPicker)
    
}

extension TextFieldPickerDelegate {
    
    // MARK: - Public Functions
    
    func didSelectField(textFieldPicker: TextFieldPicker) {
        // Optional.
    }
  
    func didSelectPickerItem(item: String, textFieldPicker: TextFieldPicker) {
        // Optional.
    }

    func didSelectPickerItems(firstItem: Int, secondItem: Int, textFieldPicker: TextFieldPicker) {
        // Optional.
    }
    
}
