//
//  FloatLabeledTextFieldBuilder.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import JVFloatLabeledTextField

struct FloatLabeledTextFieldBuilder {
    
    // MARK: - Public Functions
    
    /// Builds a float label text field with the given parameters.
    ///
    /// - Parameters:
    ///   - placeholder: Placeholder of the text field.
    ///   - floatingTitle: Title for floating label.
    ///   - theme: Custom theme of the application.
    /// - Returns: Float labled text field.
    static func buildTextField(placeholder: String?,
                               floatingTitle: String?,
                               theme: Theme) -> JVFloatLabeledTextField {
    
    // MARK: - Public Properties
    
        let textField = JVFloatLabeledTextField()
        let textStyle = theme.textStyleTheme.bodyNormal
        textField.font = textStyle.font
        textField.textColor = theme.colorTheme.emphasisQuintary
        
        textField.floatingLabelShowAnimationDuration = AnimationConstants.floatAnimationDuration
        textField.floatingLabelHideAnimationDuration = AnimationConstants.floatAnimationDuration
        
        textField.floatingLabelFont = textStyle.font.withSize(10.0)
        textField.floatingLabelTextColor = theme.colorTheme.emphasisQuaternary
        textField.floatingLabelActiveTextColor = theme.colorTheme.emphasisQuintary
        
        textField.setPlaceholder(placeholder,
                                 with: textStyle.withColor(theme.colorTheme.emphasisQuaternary),
                                 floatingTitle: floatingTitle ?? placeholder)
        textField.autocorrectionType = .no
        return textField
    }
    
    /// Builds a float label text view with the given parameters.
    ///
    /// - Parameters:
    ///   - placeholder: Placeholder text.
    ///   - floatingTitle: Floating title.
    ///   - theme: Theme.
    /// - Returns: Float labeled text view.
    static func buildTextView(placeholder: String?,
                              floatingTitle: String?,
                              theme: Theme) -> JVFloatLabeledTextView {
        let textView = JVFloatLabeledTextView(frame: .zero)
        let textStyle = theme.textStyleTheme.bodyNormal
        textView.font = textStyle.font
        textView.textColor = theme.colorTheme.emphasisQuintary
        
        textView.floatingLabelShowAnimationDuration = AnimationConstants.floatAnimationDuration
        textView.floatingLabelHideAnimationDuration = AnimationConstants.floatAnimationDuration
        
        textView.floatingLabelFont = textStyle.font.withSize(10.0)
        textView.floatingLabelTextColor = theme.colorTheme.emphasisQuaternary
        textView.floatingLabelActiveTextColor = theme.colorTheme.emphasisQuintary
        
        textView.placeholderTextColor = theme.colorTheme.tertiary
        textView.placeholderLabel.font = textStyle.font
        textView.setPlaceholder(placeholder, floatingTitle: floatingTitle)
        textView.autocorrectionType = .no

        return textView
    }
    
}
