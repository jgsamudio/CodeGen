//
//  FilterSearchNavigationViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import CoreGraphics

protocol FilterSearchNavigationViewDelegate: FilterSearchDelegate {
    
    /// Called when the back button is selected.
    func backButtonSelected()
    
    /// Called when the constraints need to be animated.
    func animateHeaderConstraints(with offset: CGFloat)
    
}
