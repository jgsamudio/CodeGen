//
//  ActivityIndicatorProtocol.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/29/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// A protocol for Activity Indicators.
protocol ActivityIndicatable {

    /// Starts the Activity Indicator.
    func startActivityIndicator()

    /// Indicates if the indicator is currently animated.
    ///
    /// - Returns: A Boolean that indicates if the indicator is currently animated.
    func isAnimating() -> Bool

    /// Stops the Activity Indicator.
    func stopActivityIndicator()

}

// MARK: - UIView ActivityIndicatable
extension UIView: ActivityIndicatable {

    /// Starts the Activity Indicator.
    func startActivityIndicator() {
        guard !isAnimating() else {
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.backgroundColor = .clear
        addSubview(activityIndicator)
        activityIndicator.pinCenterToSuperView(x: 0, y: 0)
        isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }

    /// Indicates if the indicator is currently animated.
    ///
    /// - Returns: A Boolean that indicates if the indicator is currently animated.
    func isAnimating() -> Bool {
        return subviews.filter ({ $0 is UIActivityIndicatorView }).count > 0
    }

    /// Stops the Activity Indicator.
    func stopActivityIndicator() {
        isUserInteractionEnabled = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        subviews.filter ({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
    }
}

// MARK: - UIViewController ActivityIndicatable
extension UIViewController: ActivityIndicatable {

    /// Starts the Activity Indicator.
    func startActivityIndicator() {
        view.startActivityIndicator()
    }

    /// Indicates if the indicator is currently animated.
    ///
    /// - Returns: A Boolean that indicates if the indicator is currently animated.
    public func isAnimating() -> Bool {
        return view.isAnimating()
    }

    /// Stops the Activity Indicator.
    public func stopActivityIndicator() {
        view.stopActivityIndicator()
    }

}
