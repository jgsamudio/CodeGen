//
//  PilasScrollViewExtensions.swift
//  TheWing
//
//  Created by Paul Jones on 7/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Pilas

extension PilasScrollView {
    
    // MARK: - Initialization
    
    /// a convinience intializer for stack view which conviniently wraps up all the things you probably want to set.
    ///
    /// - Parameters:
    ///   - arrangedSubviews: what subviews do you want in the stack view
    ///   - axis: the axis of the stack view
    ///   - distribution: the distribution of the stack view
    ///   - alignment: the alignment of the stack view
    ///   - spacing: the spacing of the stack view
    public convenience init(alignment: UIStackViewAlignment,
                            distribution: UIStackViewDistribution,
                            axis: UILayoutConstraintAxis,
                            spacing: CGFloat = 0) {
        self.init()
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }
    
}
