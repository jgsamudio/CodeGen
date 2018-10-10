//
//  UIStackViewExtension.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

extension UIStackView {
    
    // MARK: - Public Functions
    
    /// Removes all arranged subviews.
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Initialization
    
    /// a convinience intializer for stack view which conviniently wraps up all the things you probably want to set.
    ///
    /// - Parameters:
    ///   - arrangedSubviews: what subviews do you want in the stack view
    ///   - axis: the axis of the stack view
    ///   - distribution: the distribution of the stack view
    ///   - alignment: the alignment of the stack view
    ///   - spacing: the spacing of the stack view
    convenience init(arrangedSubviews: [UIView],
                     axis: UILayoutConstraintAxis,
                     distribution: UIStackViewDistribution,
                     alignment: UIStackViewAlignment,
                     spacing: CGFloat = 0) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }
    
}
