//
//  TopDrawerPresenter.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/4/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Protocol for classes that are able to present a top drawer and react to the animation.
protocol TopDrawerPresenter: class {

    /// Current offset of the presented view.
    var topDrawerContentOffset: CGFloat { get set }

    /// Interactor for dismissal.
    var topDrawerDismissalInteractor: TopDrawerTransitionAnimator { get }

}
