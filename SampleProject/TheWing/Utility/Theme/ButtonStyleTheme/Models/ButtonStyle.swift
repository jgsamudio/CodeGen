//
//  ButtonStyle.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Style of a button with different states.
struct ButtonStyle {

	// MARK: - Public Properties

    // MARK: - Public Properties
    
    /// Normal button style.
    let normalStyle: ButtonStateStyle?

    /// Highlighted button style.
    let highlightedStyle: ButtonStateStyle?

    /// Selected button style.
    let selectedStyle: ButtonStateStyle?

    /// Disabled button style.
    let disabledStyle: ButtonStateStyle?

	// MARK: - Initialization

    // MARK: - Initialization
    
    init(normalStyle: ButtonStateStyle? = nil,
         highlightedStyle: ButtonStateStyle? = nil,
         selectedStyle: ButtonStateStyle? = nil,
         disabledStyle: ButtonStateStyle? = nil) {
        
        self.normalStyle = normalStyle
        self.highlightedStyle = highlightedStyle
        self.selectedStyle = selectedStyle
        self.disabledStyle = disabledStyle
    }

}
