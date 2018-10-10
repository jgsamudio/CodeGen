//
//  Styleable.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import Foundation

/// Protocol for styleable UI elements.
@objc protocol Styleable: class {

    /// Text style row.
    var row: Int { get set }

    /// Text style column.
    var column: Int { get set }

    /// Applies the currently selected style to `self`.
    func applyStyle()

}

// MARK: - Helper functions.
extension Styleable {

    // MARK: - Public Functions
    
    /// Prepares `self` to re-apply the style if the content size category changed. (Accessibility)
    func prepareForDynamicType() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applyStyle),
                                               name: NSNotification.Name.UIContentSizeCategoryDidChange,
                                               object: nil)
    }

}
