//
//  PureLayoutExtensions.swift
//  TheWing
//
//  Created by Paul Jones on 7/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import PureLayout

extension UIView {
    
    // MARK: - Public Functions
    
    /// Auto pins all edges except the one you specify to the superview with no margin.
    ///
    /// - Parameter edge: what edge do you not want pinned?
    /// - Returns: the constraints created from this operation
    @discardableResult func autoPinEdgesToSuperviewEdges(excludingEdge edge: ALEdge) -> [NSLayoutConstraint] {
        return autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: edge)
    }
    
    // MARK: - Initialization
    
    /// Creates a divider view with height and a constant.
    ///
    /// - Parameters:
    ///   - constant: how big?
    ///   - backgroundColor: optional background color, often needed in container views
    convenience init(verticalDividerWithConstant constant: CGFloat,
                     backgroundColor: UIColor? = nil) {
        self.init()
        self.backgroundColor = backgroundColor
        autoSetDimension(.height, toSize: constant)
    }
    
    /// Create a divider with both width and height and an optional background color.
    ///
    /// - Parameters:
    ///   - size: what size do you want it to be?
    ///   - backgroundColor: do you want it to have a background color?
    convenience init(dividerWithSize size: CGSize,
                     backgroundColor: UIColor? = nil) {
        self.init()
        self.backgroundColor = backgroundColor
        autoSetDimensions(to: size)
    }
    
    /// Auto match one dimension between two views to the same value.
    ///
    /// - Parameters:
    ///   - dimension: height or width?
    ///   - view: the view you want to match to
    /// - Returns: the layout constraint that's created
    @discardableResult func autoMatch(_ dimension: ALDimension, of view: UIView) -> NSLayoutConstraint {
        return autoMatch(dimension,
                         to: dimension,
                         of: view,
                         withMultiplier: 1,
                         relation: .equal)
    }
    
    /// Creates a divider view with a dimension and a constant.
    ///
    /// - Parameters:
    ///   - dimension: width or height
    ///   - constant: how big?
    ///   - backgroundColor: optional background color, often needed in container views
    convenience init(dividerWithDimension dimension: ALDimension,
                     constant: CGFloat,
                     backgroundColor: UIColor? = nil) {
        self.init()
        self.backgroundColor = backgroundColor
        autoSetDimension(dimension, toSize: constant)
    }
    
    /// Adds the view as subview and `autoPinEdgesToSuperviewEdges`
    ///
    /// - Parameters:
    ///   - subview: the view contained within this one
    ///   - backgroundColor: optional background color, often needed in container views
    convenience init(containerWithSubview subview: UIView,
                     backgroundColor: UIColor? = nil) {
        self.init()
        addSubview(subview)
        self.backgroundColor = backgroundColor
        subview.autoPinEdgesToSuperviewEdges()
    }

}
