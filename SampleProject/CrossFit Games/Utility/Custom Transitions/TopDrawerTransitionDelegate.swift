//
//  TopDrawerTransitionDelegate.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/4/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

final class TopDrawerTransitionDelegate: NSObject, TopDrawerPresenter, UIViewControllerTransitioningDelegate {

    // MARK: - Public Properties
    
    lazy var topDrawerDismissalInteractor = {
        return TopDrawerTransitionAnimator(isPresenting: false, initialContentOffset: initialContentOffset)
    }()

    let contentOffsetChanged: (CGFloat) -> Void

    let initialContentOffset: () -> CGFloat

    var topDrawerContentOffset: CGFloat = 0 {
        didSet {
            contentOffsetChanged(topDrawerContentOffset)
        }
    }

    // MARK: - Initialization
    
    init(initialContentOffset: @escaping () -> CGFloat,
         contentOffsetChanged: @escaping (CGFloat) -> Void = { _ in }) {
        self.initialContentOffset = initialContentOffset
        self.contentOffsetChanged = contentOffsetChanged
    }

    // MARK: - Public Functions
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        if let presented = presented as? UINavigationController, presented.viewControllers.first is FilterViewController {
            let topViewHeight: CGFloat
            if #available(iOS 11.0, *) {
                topViewHeight = TopDrawerTransitionController.defaultPresentationHeight
                    + UIApplication.shared.statusBarFrame.height
            } else {
                topViewHeight = TopDrawerTransitionController.defaultPresentationHeight
            }
            return TopDrawerTransitionController(presentedViewController: presented,
                                                 presenting: presenting?.navigationController ?? presenting,
                                                 topDrawerPresenter: self,
                                                 height: topViewHeight)
        } else {
            return nil
        }
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TopDrawerTransitionAnimator(isPresenting: true, initialContentOffset: initialContentOffset)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return topDrawerDismissalInteractor
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? TopDrawerTransitionAnimator else {
            return nil
        }

        if animator.wantsInteractiveStart {
            return animator
        } else {
            return nil
        }
    }

}
