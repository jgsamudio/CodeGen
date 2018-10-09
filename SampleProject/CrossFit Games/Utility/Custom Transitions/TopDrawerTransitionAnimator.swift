//
//  TopDrawerTransitionAnimator.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/30/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

final class TopDrawerTransitionAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {

    /// Indicates whether `self` is used for presenting a view or dismissing.
    let isPresenting: Bool

    let initialContentOffset: () -> CGFloat

    init(isPresenting: Bool, initialContentOffset: @escaping () -> CGFloat) {
        self.isPresenting = isPresenting
        self.initialContentOffset = initialContentOffset
        super.init()

        wantsInteractiveStart = false
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedViewController = isPresenting
            ? transitionContext.viewController(forKey: .to)
            : transitionContext.viewController(forKey: .from) else {
                return
        }

        let finalFrame = transitionContext.finalFrame(for: presentedViewController)
        let initialFrame = finalFrame.offsetBy(dx: 0, dy: -finalFrame.height + initialContentOffset())
        let containerView = transitionContext.containerView

        if isPresenting {
            containerView.addSubview(presentedViewController.view)
            presentedViewController.view.frame = initialFrame
            presentedViewController.view.alpha = 0
        } else {
            presentedViewController.view.frame = finalFrame
            presentedViewController.view.alpha = 1
        }

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        presentedViewController.view.frame = self.isPresenting ? finalFrame : initialFrame
                        presentedViewController.view.alpha = self.isPresenting ? 1 : 0
        }, completion: { [weak self] _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if let wself = self, !wself.isPresenting && !transitionContext.transitionWasCancelled {
                presentedViewController.view.removeFromSuperview()
            }
        })
    }

}
