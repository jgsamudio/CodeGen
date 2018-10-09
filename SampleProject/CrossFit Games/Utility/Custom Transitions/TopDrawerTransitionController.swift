//
//  TopDrawerTransitionController.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/30/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Controller for presenting and dismissing a top drawer.
final class TopDrawerTransitionController: UIPresentationController {

    private let presentationHeight: CGFloat

    static let defaultPresentationHeight: CGFloat = 408

    /// Presenter which will be notified about presentation content offset.
    weak var topDrawerPresenter: TopDrawerPresenter?

    private var panGestureView: UIView?

    private var interactiveFeedbackGenerator: UISelectionFeedbackGenerator?

    /// Creates a new instance of TopDrawerTransitionController and sets the top drawer presenter.
    ///
    /// - Parameters:
    ///   - presentedViewController: Presented view controller.
    ///   - presentingViewController: Presenting view controller.
    ///   - topDrawerPresenter: Presenter which will be notified about presentation content offset.
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         topDrawerPresenter: TopDrawerPresenter?,
         height: CGFloat = TopDrawerTransitionController.defaultPresentationHeight) {
        self.presentationHeight = height

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.topDrawerPresenter = topDrawerPresenter
    }

    override var presentationStyle: UIModalPresentationStyle {
        return .overCurrentContext
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerFrame = containerView?.bounds else {
            return .zero
        }

        let maxSize = CGSize(width: .greatestFiniteMagnitude,
                             height: presentationHeight)

        return containerFrame.intersection(CGRect(origin: .zero, size: maxSize))
    }

    override func presentationTransitionWillBegin() {
        if let containerView = containerView, let presentedView = presentedView {
            let panGestureView = UIView(frame: containerView.bounds)
            self.panGestureView = panGestureView
            containerView.insertSubview(panGestureView, belowSubview: presentedView)
            panGestureView.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                                       action: #selector(panGestureHappened(_:))))
            panGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                       action: #selector(tapGestureHappened(_:))))
            presentedView.layoutIfNeeded()
        }

        presentedViewController.transitionCoordinator?
            .animateAlongsideTransition(in: presentingViewController.view,
                                        animation: { (_) in
                                            self.topDrawerPresenter?.topDrawerContentOffset = self.presentationHeight
            }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?
            .animateAlongsideTransition(in: presentingViewController.view,
                                        animation: { (_) in
                                            self.topDrawerPresenter?.topDrawerContentOffset = 0
            }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            panGestureView?.removeFromSuperview()
        }
    }

    @objc private func tapGestureHappened(_ gestureRecognizer: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
        topDrawerPresenter?.topDrawerDismissalInteractor.finish()
    }

    @objc private func panGestureHappened(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let topDrawerPresenter = topDrawerPresenter else {
            self.presentedViewController.dismiss(animated: true, completion: nil)
            return
        }

        let translation = gestureRecognizer.translation(in: presentedViewController.view).y
        let dy = min(1.0, max(-translation / (containerView?.bounds.height ?? .leastNonzeroMagnitude), 0.0))

        switch gestureRecognizer.state {
        case .began:
            interactiveFeedbackGenerator = UISelectionFeedbackGenerator()
            interactiveFeedbackGenerator?.prepare()
            topDrawerPresenter.topDrawerDismissalInteractor.wantsInteractiveStart = true
            presentedViewController.dismiss(animated: true, completion: nil)
        case .changed:
            if dy <= 0.3 {
                topDrawerPresenter.topDrawerDismissalInteractor.update(dy)
            } else {
                topDrawerPresenter.topDrawerDismissalInteractor.finish()
                interactiveFeedbackGenerator?.selectionChanged()
                interactiveFeedbackGenerator = nil
                topDrawerPresenter.topDrawerDismissalInteractor.wantsInteractiveStart = false
            }
        case .ended:
            if dy <= 0.3 {
                topDrawerPresenter.topDrawerDismissalInteractor.cancel()
                topDrawerPresenter.topDrawerDismissalInteractor.wantsInteractiveStart = false
            }
        default:
            return
        }
    }

}
