//
//  UIButtonExtensions.swift
//  TheWing
//
//  Created by Paul Jones on 7/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Marker

extension UIButton {
    
    // MARK: - Initialization
    
    /// Creates a button and let's you pass in Marker configuration as initialization paramters.
    ///
    /// Feel free to add more optional configuration parameters.
    ///
    /// - Parameters:
    ///   - text: What text do you want the button to say?
    ///   - textStyle: What style would you like the button to have?
    ///   - contentHorizontalAlignment: @optional, the alignment of the button's text horizontally
    convenience init(text: String,
                     textStyle: TextStyle,
                     contentHorizontalAlignment: UIControlContentHorizontalAlignment = .left) {
        self.init()
        setTitleText(text, using: textStyle)
        self.contentHorizontalAlignment = contentHorizontalAlignment
    }
    
}
