//
//  UIEdgeInsetExtension.swift
//  TheWing
//
//  Created by Paul Jones on 8/3/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    
    // MARK: - Initialization
    
    /// Creates a UIEdgeInset with the passed in value all around
    ///
    /// - Parameter value: the value you want all around
    init(inset value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
    
    /// Convinence that allows you to specify just the edges you want, get zero for rest.
    ///
    /// - Parameters:
    ///   - top: top or zero
    ///   - left: left or zero
    ///   - bottom: bottom or zero
    ///   - right: right or zero
    init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        self.init()
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
    
}
