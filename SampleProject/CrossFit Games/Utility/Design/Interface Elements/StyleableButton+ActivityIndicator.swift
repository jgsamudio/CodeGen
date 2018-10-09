//
//  StyleableButton+ActivityIndicator.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/27/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// A helper to include an activity indicator view in a button and
/// and show/hide by two functions based on the preference
extension StyleableButton {

    // MARK: - Public Functions
    
    /// Shows activity indicator in the button
    ///
    /// - Parameter color: the color of the activity indicator (defaults to light gray)
    func showLoading(withColor color: UIColor = UIColor.lightGray) {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: UIControlState.normal)

        if activityIndicator == nil {
            createActivityIndicator(withColor: color)
        }

        showSpinning()
    }

    /// Hides activity indicator animation, and brings the button to the original state
    func hideLoading() {
        self.setTitle(originalButtonText, for: UIControlState.normal)
        if let activityIndicator = activityIndicator {
            activityIndicator.stopAnimating()
        }
        activityIndicator = nil
    }

    private func createActivityIndicator(withColor color: UIColor = UIColor.lightGray) {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = color
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
    
    // MARK: - Public Properties
    
        let xCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0)
        self.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerY,
                                                   multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
