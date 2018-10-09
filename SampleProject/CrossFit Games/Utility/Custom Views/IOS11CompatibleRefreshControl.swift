//
//  IOS11CompatibleRefreshControl.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Refresh control that does **not** start flickering and causing epileptic seizures when a user scrolls in
/// a view with one of those giant iOS 11 navigation bars.
class IOS11CompatibleRefreshControl: UIRefreshControl {

    override var isHidden: Bool {
        get {
            return !isRefreshing
        }
        set {
            guard !isRefreshing else {
                return
            }
            super.isHidden = newValue
        }
    }

    override func endRefreshing() {
        super.endRefreshing()
        super.isHidden = true
    }

}
