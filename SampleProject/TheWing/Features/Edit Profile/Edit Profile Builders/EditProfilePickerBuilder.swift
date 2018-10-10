//
//  EditProfilePickerBuilder.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EditProfilePickerBuilder {

    // MARK: - Private Properties

    private let theme: Theme

    private weak var superView: UIView?

    // MARK: - Initialization

    init(theme: Theme, superView: UIView?) {
        self.theme = theme
        self.superView = superView
    }

    // MARK: - Public Functions

    /// Builds an industry text field picker.
    ///
    /// - Parameters:
    ///   - delegate: Delegate for the text field picker.
    ///   - placeholder: Place holder.
    ///   - floatingTitle: Floating title.
    /// - Returns: Text field picker.
    func buildIndustryPicker(delegate: TextFieldPickerDelegate? = nil,
                             placeholder: String,
                             floatingTitle: String) -> TextFieldPicker {
    
    // MARK: - Public Properties
    
        let fieldView = PickerFieldView(placeholder: placeholder, floatingTitle: floatingTitle, theme: theme)

        let pickerView = BarPickerView(theme: theme)
        pickerView.barTitle = "SELECT_INDUSTRY".localized(comment: "Select Industry")

        let transitioner = BottomTransitionViewContainer(transitionView: pickerView, superView: superView)

        let textFieldPicker = TextFieldPicker(fieldView: fieldView, pickerView: pickerView, transitioner: transitioner)
        textFieldPicker.delegate = delegate

        return textFieldPicker
    }
    
    /// Builds a birthday text field picker.
    ///
    /// - Parameter delegate: Delegate for the text field picker.
    /// - Returns: Text field picker.
    func buildBirthdayPicker(delegate: TextFieldPickerDelegate? = nil) -> TextFieldPicker {
        let placeholder = "BIRTHDAY".localized(comment: "Birthday")
        let floatingTitle = placeholder
        let fieldView = PickerFieldView(placeholder: placeholder, floatingTitle: floatingTitle, theme: theme)
        
        let pickerView = BarDatePickerView(theme: theme)
        pickerView.barTitle = "SELECT_BIRTHDAY".localized(comment: "Select Birthday")
        
        let transitioner = BottomTransitionViewContainer(transitionView: pickerView, superView: superView)
        
        let textFieldPicker = TextFieldPicker(fieldView: fieldView, datePickerView: pickerView, transitioner: transitioner)
        textFieldPicker.delegate = delegate
        
        return textFieldPicker
    }

    /// Builds a star sign text field picker.
    ///
    /// - Parameter delegate: Delegate for the text field picker.
    /// - Returns: Text field picker.
    func buildStarSignPicker(delegate: TextFieldPickerDelegate? = nil) -> TextFieldPicker {
        let placeholder = "STAR_SIGN_QUESTION".localized(comment: "What's your star sign?")
        let floatingTitle = "STAR_SIGN".localized(comment: "Star Sign")
        let fieldView = PickerFieldView(placeholder: placeholder, floatingTitle: floatingTitle, theme: theme)

        let pickerView = BarPickerView(theme: theme)
        pickerView.barTitle = "SELECT_STAR_SIGN".localized(comment: "Select Star Sign")

        let transitioner = BottomTransitionViewContainer(transitionView: pickerView, superView: superView)

        let textFieldPicker = TextFieldPicker(fieldView: fieldView, pickerView: pickerView, transitioner: transitioner)
        textFieldPicker.delegate = delegate

        return textFieldPicker
    }

}
