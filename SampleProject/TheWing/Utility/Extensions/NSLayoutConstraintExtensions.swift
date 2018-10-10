//
//  NSLayoutConstraintExtensions.swift
//  TheWing
//
//  Created by Paul Jones on 9/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    // MARK: - Initialization
    
    /// A convenience initializer that makes reasonable assumptions about the related
    /// initializer in NSLayoutConstraint, including isActive to activate it immediately.
    convenience init(item view1: Any,
                     attribute sharedAttribute: NSLayoutAttribute = .notAnAttribute,
                     relatedBy relation: NSLayoutRelation = .equal,
                     toItem view2: Any? = nil,
                     multiplier: CGFloat = 1,
                     constant: CGFloat = 0,
                     isActive: Bool = false) {
        self.init(item: view1,
                  attribute: sharedAttribute,
                  relatedBy: relation,
                  toItem: view2,
                  attribute: sharedAttribute,
                  multiplier: multiplier,
                  constant: constant)
        self.isActive = isActive
    }
    
    /// A convenience initializer that makes reasonable assumptions about the related
    /// initializer in NSLayoutConstraint, including isActive to activate it immediately.
    convenience init(item view1: Any,
                     attribute attr1: NSLayoutAttribute = .notAnAttribute,
                     relatedBy relation: NSLayoutRelation = .equal,
                     toItem view2: Any? = nil,
                     attribute attr2: NSLayoutAttribute,
                     multiplier: CGFloat = 1,
                     constant: CGFloat,
                     isActive: Bool = false) {
        self.init(item: view1,
                  attribute: attr1,
                  relatedBy: relation,
                  toItem: view2,
                  attribute: attr2,
                  multiplier: multiplier,
                  constant: constant)
        self.isActive = isActive
    }
    
}
