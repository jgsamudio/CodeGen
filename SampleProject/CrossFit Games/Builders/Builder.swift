//
//  Builder.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/20/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Common builder protocol for any view controller builders.
protocol Builder {

    /// Creates a new view controller with all dependencies injected.
    ///
    /// - Returns: View controller, ready to be added to the view hierarchy.
    func build() -> UIViewController
}
