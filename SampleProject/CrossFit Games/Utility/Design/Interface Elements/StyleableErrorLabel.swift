//
//  StyleableLabel+Error.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/4/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Handles labels for error situations
class StyleableErrorLabel: StyleableLabel, CAAnimationDelegate {

    @IBInspectable var isError: Bool = false {
        didSet {
            initForError()
        }
    }

    /// Initializes the label to handle the error states
    func initForError() {
        layer.opacity = 0
        text = ""
    }

    /// Shows an error message with an animation added
    ///
    /// - Parameter error: error message to be displayed
    func showError(error: String) {
        text = error
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        self.layer.add(animation, forKey: nil)
    }

    /// Clears the text in the label
    func clearError() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.5
        animation.fromValue = 1
        animation.toValue = 0
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        layer.add(animation, forKey: "clearErrorAnimation")
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == layer.animation(forKey: "clearErrorAnimation") {
            text = ""
        }
    }
}
