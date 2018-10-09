//
//  CardDetailContainerDelegate.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/20/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Delegate that gets notified about changes in the surrounding Card Detail Container.
protocol CardDetailContainerDelegate: class {

    /// Callback that gets invoked when the card detail container moved `self` and changed the visibility (range: [0, 1])
    ///
    /// - Parameters:
    ///   - container: Container view that the user used to swipe to the next card.
    ///   - visibility: Visibility in a range from 0 to 1, indicating how much of `self` is visible.
    func container(_ container: CardDetailContainerViewController, changedVisibility visibility: CGFloat)

}
