//
//  JVFloatLabeledTextFieldExtension.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Marker
import JVFloatLabeledTextField

extension JVFloatLabeledTextField {
    
    // MARK: - Public Functions
    
    /// Sets placeholder with given text style object.
    ///
    /// - Parameters:
    ///   - placeholder: Placeholder string.
    ///   - textStyle: Text style.
    ///   - floatingTitle: Floating title.
    func setPlaceholder(_ placeholder: String?, with textStyle: TextStyle, floatingTitle: String?) {
        guard let placeholder = placeholder, let floatingTitle = floatingTitle else {
            return
        }
        
    // MARK: - Public Properties
    
        let attributedString = attributedMarkdownString(from: placeholder, using: textStyle)
        setAttributedPlaceholder(attributedString, floatingTitle: floatingTitle)
    }
    
}
