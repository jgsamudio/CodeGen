//
//  ButtonStateStyle.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Marker

/// Style for a particular state of a button.
struct ButtonStateStyle {

	// MARK: - Public Properties

    // MARK: - Public Properties
    
    /// Text style for the title.
    let titleTextStyle: TextStyle

    /// Border model for button's border.
    let border: Border?

    /// Background color of the button.
    let backgroundColor: UIColor

    /// Corner radius of the button.
    let cornerRadius: CGFloat
}
