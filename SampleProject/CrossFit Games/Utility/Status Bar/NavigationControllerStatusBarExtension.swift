//
//  NavigationControllerStatusBarExtension.swift
//  CrossFit Games
//
//  Created by Phill Farrugia on 1/24/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// An extension on UINavigationController which overrides the
/// default `preferredStatusBarStyle` and uses either the override
/// value specified on the Top Most View Controller, or the default.
extension UINavigationController {

    // MARK: - Public Properties
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }

}
