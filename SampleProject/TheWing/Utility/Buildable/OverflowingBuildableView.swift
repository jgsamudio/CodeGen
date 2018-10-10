//
//  OverflowingBuildableView.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// UIView subclass in which subviews are hittable even if they are outside of the bounds of the superview.
class OverflowingBuildableView: BuildableView {

    // MARK: - Public Functions
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews {
            if let view = subview.hitTest(convert(point, to: subview), with: event) {
                return view
            }
        }
        return super.hitTest(point, with: event)
    }
    
}
