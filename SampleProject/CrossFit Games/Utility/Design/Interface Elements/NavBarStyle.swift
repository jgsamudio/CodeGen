//
//  NavBarStyle.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Navigation bar styles for the app.
struct NavBarStyle {

    /// Default nav bar style in the app.
    static let `default` = NavBarStyle(backgroundImage: UIImage(), tintColor: StyleColumn.c2.color, shadowImage: UIImage(), isTranslucent: true)

    /// Default style for authentication views.
    static let auth = NavBarStyle(backgroundImage: UIImage(), tintColor: .white, shadowImage: UIImage(), isTranslucent: true)

    /// Blurry style for leaderboard views (upcoming).
    static let blurry = NavBarStyle(backgroundImage: nil, tintColor: StyleColumn.c2.color, shadowImage: nil, isTranslucent: false)

    /// Background image for the nav bar.
    let backgroundImage: UIImage?

    /// Tint color for the nav bar.
    let tintColor: UIColor?

    /// Shadow image for the nav bar.
    let shadowImage: UIImage?

    /// Indicates whether the app will be translucent.
    let isTranslucent: Bool

    init(backgroundImage: UIImage?, tintColor: UIColor?, shadowImage: UIImage?, isTranslucent: Bool) {
        self.backgroundImage = backgroundImage
        self.tintColor = tintColor
        self.shadowImage = shadowImage
        self.isTranslucent = isTranslucent
    }

    init(navBar: UINavigationBar?) {
        self.init(backgroundImage: navBar?.backgroundImage(for: .default),
                  tintColor: navBar?.tintColor,
                  shadowImage: navBar?.shadowImage,
                  isTranslucent: navBar?.isTranslucent ?? false)
    }

    /// Applies `self` to the given navigation bar.
    ///
    /// - Parameter navBar: Navigation bar.
    func apply(to navBar: UINavigationBar?) {
        navBar?.setBackgroundImage(backgroundImage, for: UIBarMetrics.default)
        navBar?.shadowImage = shadowImage
        navBar?.tintColor = tintColor
        navBar?.isTranslucent = isTranslucent
    }

}
