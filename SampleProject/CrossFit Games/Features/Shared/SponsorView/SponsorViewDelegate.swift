//
//  SponsorViewDelegate.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 1/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Handles call backs for Sponsor View
@objc protocol SponsorViewDelegate: class {

    /// Triggered whenever logo is tapped
    ///
    /// - Parameter url: URL to eventually use for web request
    func tappedLogo(url: URL)

}
