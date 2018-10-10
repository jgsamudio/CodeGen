//
//  UILabelExtension.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Marker

extension UILabel {
    
    // MARK: - Initialization
    
    /// Initializes label with given number of lines.
    ///
    /// - Parameter numberOfLines: Number of lines.
    convenience init(numberOfLines: Int) {
        self.init()
        self.numberOfLines = numberOfLines
    }
    
    /// Convenience initializer taking marker style and number of lines.
    ///
    /// Please feel free to add more configuration parameters
    ///
    /// - Parameters:
    ///   - text: What should the label say?
    ///   - textStyle: What should the label look like?
    ///   - color: Do you want a custom color?
    ///   - numberOfLines: How many lines should the label have? Default, optional, 0
    ///   - alignment: What alignment do you want? Default left.
    convenience init(text: String = "",
                     using textStyle: TextStyle,
                     with color: UIColor? = nil,
                     numberOfLines: Int = 0,
                     alignment: NSTextAlignment = .left) {
        self.init()
    
    // MARK: - Public Properties
    
        var aTextStyle = textStyle
        if let color = color {
            aTextStyle = aTextStyle.withColor(color)
        }
        setText(text, using: aTextStyle)
        self.numberOfLines = numberOfLines
        self.textAlignment = alignment
    }
    
}
