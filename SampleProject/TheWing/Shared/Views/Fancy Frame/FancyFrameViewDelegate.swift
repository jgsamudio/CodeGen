//
//  FancyFrameViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 7/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Fancy frame view delegate.
protocol FancyFrameViewDelegate: class {
    
    /// Called to indicate if image loaded.
    ///
    /// - Parameter loaded: Flag to determine the loaded state.
    func imageLoaded(_ loaded: Bool)
    
}
