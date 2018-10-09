//
//  UIViewController+MotionGesture.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
#if !RELEASE
    import Yoshi
#endif

extension UIWindow {

    /// Function returning the amount of touch required to show Yoshi from a mulitple touch.
    /// Override this function to update the value.
    ///
    /// - Returns: count of touch required to show Yoshi.
    func yoshiTouchesBeganMinimumTouchRequirement() -> Int {
        return 3
    }

    /// Function returning the amount of force required to show Yoshi from a force touch.
    /// Override this function to update the value.
    ///
    /// - Returns: value of force required to show Yoshi.
    func yoshiTouchesMovedMinimumForcePercent() -> Float {
        return 60
    }

    override open func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        #if !RELEASE
        Yoshi.motionBegan(motion, withEvent: event)
        #endif
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        #if !RELEASE
        Yoshi.touchesBegan(touches, withEvent: event, minimumTouchRequirement: yoshiTouchesBeganMinimumTouchRequirement())
        #endif
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        #if !RELEASE
        Yoshi.touchesMoved(touches, withEvent: event, minimumForcePercent: yoshiTouchesMovedMinimumForcePercent())
        #endif
    }
}
