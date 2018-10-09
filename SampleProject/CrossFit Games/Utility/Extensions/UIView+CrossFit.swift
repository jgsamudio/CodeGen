//
//  UIView+CrossFit.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/29/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import Shimmer

extension UIView {

    // MARK: - Public Functions
    
    /// Pin to superview. Ensure view is already added to view hierarchy. All nil values are ignored.
    ///
    /// - Parameters:
    ///   - top: Constant to apply to top
    ///   - leading: Constant to apply to leading
    ///   - bottom: Constant to apply to bottom
    ///   - trailing: Constant to apply to trailing
    /// - Returns: List of NSLayoutConstraints applied in following order: top, leading, bottom, trailing
    @discardableResult
    func pinToSuperview(top: CGFloat? = nil,
                        leading: CGFloat? = nil,
                        bottom: CGFloat? = nil,
                        trailing: CGFloat? = nil) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            return [NSLayoutConstraint]()
        }

        return pin(to: superview, top: top, leading: leading, bottom: bottom, trailing: trailing)
    }

    /// Update the size of the view
    ///
    /// - Parameters:
    ///   - width: the width to be updated
    ///   - height: the height to be updated
    /// - Returns: List of NSLayoutConstraints applied in following order: top, leading, bottom, trailing
    @discardableResult
    func pinSize(width: CGFloat? = nil, height: CGFloat? = nil) -> [NSLayoutConstraint] {
    
    // MARK: - Public Properties
    
        var constraintList = [NSLayoutConstraint]()
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            constraintList.append(widthAnchor.constraint(equalToConstant: width))
        }
        if let height = height {
            constraintList.append(heightAnchor.constraint(equalToConstant: height))
        }
        constraintList.forEach { $0.isActive = true }
        return constraintList
    }

    /// Pin the center of this view to its superview
    ///
    /// - Parameters:
    ///   - x: xOffset
    ///   - y: yOffset
    /// - Returns: List of NSLayoutConstraints applied in following order: xOffset, yOffset
    @discardableResult
    func pinCenterToSuperView(x: CGFloat?, y: CGFloat?) -> [NSLayoutConstraint] {
        var constraintList = [NSLayoutConstraint]()
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else {
            return constraintList
        }
        if let x = x {
            constraintList.append(centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: x))
        }
        if let y = y {
            constraintList.append(centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: y))
        }
        constraintList.forEach { $0.isActive = true }
        return constraintList
    }

    /// Pin to another view. Ensure view is already added to view hierarchy. All nil values are ignored.
    ///
    /// - Parameters:
    ///   - view: Other view to pin to
    ///   - top: Constant to apply to top
    ///   - leading: Constant to apply to leading
    ///   - bottom: Constant to apply to bottom
    ///   - trailing: Constant to apply to trailing
    /// - Returns: List of NSLayoutConstraints applied in following order: top, leading, bottom, trailing
    @discardableResult
    func pin(to view: UIView,
             top: CGFloat? = nil,
             leading: CGFloat? = nil,
             bottom: CGFloat? = nil,
             trailing: CGFloat? = nil) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var constraintList = [NSLayoutConstraint]()
        if let top = top {
            constraintList.append(topAnchor.constraint(equalTo: view.topAnchor, constant: top))
        }
        if let leading = leading {
            constraintList.append(leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading))
        }
        if let bottom = bottom {
            constraintList.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom))
        }
        if let trailing = trailing {
            constraintList.append(trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing))
        }
        constraintList.forEach { $0.isActive = true }
        return constraintList
    }

    /// If a shimmer has not already been added, a shimmer view will be added as a subview
    func startShimmer() {
        if subviews.contains (where: { $0 is FBShimmeringView }) {
            return
        }
        let shimmerview = FBShimmeringView(frame: frame)
        superview?.addSubview(shimmerview)
        shimmerview.contentView = self
        shimmerview.isShimmering = true
        shimmerview.shimmeringPauseDuration = 0.10
        shimmerview.shimmeringAnimationOpacity = 0
        shimmerview.shimmeringOpacity = 1
        shimmerview.shimmeringSpeed = 320
        shimmerview.shimmeringHighlightLength = 1
    }

    /// Sets up a xib for storyboard. Ensure File's owner is set and the view's call is not set.
    /// See `SponserView.xib` for reference
    func setupForStoryboardUse() {
        guard let v = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView else {
            return
        }
        addSubview(v)
        v.frame = bounds
    }

    /// Fades the presented view controller on the app's key window to a different view controller.
    ///
    /// - Parameters
    ///   - newViewController: New view controller to fade to.
    ///   - completion: completion block to notify the presenting view controller that the fade presentation is completed
    static func fadePresentedViewController(to newViewController: UIViewController, completion: @escaping () -> Void = {}) {
        let window: UIWindow = UIApplication.shared.keyWindow!
        weak var previousViewController = window.rootViewController
        UIView.transition(with: window,
                          duration: 0.4, options: .transitionCrossDissolve,
                          animations: {
                            let viewController = UIViewController()
                            viewController.view.backgroundColor = .white
                            UIApplication.shared.keyWindow?.rootViewController = viewController
        }, completion: { completed in
            guard completed else {
                return
            }
            previousViewController?.dismiss(animated: false, completion: {
                previousViewController?.view.removeFromSuperview()
            })
            UIView.transition(with: window,
                              duration: 0.4, options: .transitionCrossDissolve,
                              animations: {
                                UIApplication.shared.keyWindow?.rootViewController = newViewController
            }, completion: {
                if $0 {
                    completion()
                }
            })
        })
    }

    /// Applies a border to the button based on the provided color and the thickness
    ///
    /// - Parameters:
    ///   - color: required border color
    ///   - borderWidth: thickness of the border
    func applyBorder(withColor color: UIColor, borderWidth: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = borderWidth
    }

}
