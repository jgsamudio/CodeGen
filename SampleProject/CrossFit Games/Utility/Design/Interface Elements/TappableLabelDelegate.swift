//
//  TappableLabelDelegate.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/16/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Delegate protocol for tappable labels.
internal protocol TappableLabelDelegate: class {

    /// Event that gets called when a user tapped on any of the label's tappable strings.
    ///
    /// - Parameters:
    ///   - label: The label on which the action was performed
    ///   - index: The index of the tapped string.
    ///   - content: The content of the tapped string.
    func tappableLabel(_ label: TappableLabel, didTapLinkAtIndex index: Int, withContent content: String)

}
