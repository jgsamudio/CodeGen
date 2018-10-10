//
//  BottomTransitionViewContainer.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class BottomTransitionViewContainer {

    // MARK: - Public Properties

    private(set) var isVisible = false

    // MARK: - Private Properties

    private weak var superView: UIView?

    private let transitionView: UIView
    private let bottomOffset: CGFloat

    fileprivate var topTransitionViewConstraint: NSLayoutConstraint?

    fileprivate var visibleConstant: CGFloat {
        return -(transitionView.frame.height + bottomOffset)
    }

    fileprivate var hiddenConstant: CGFloat {
        return 0
    }

    // MARK: - Initialization

    required init(transitionView: UIView, superView: UIView?, bottomOffset: CGFloat = 0) {
        self.transitionView = transitionView
        self.superView = superView
        self.bottomOffset = bottomOffset
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Shows the view.
    func show() {
        transition(visible: true)
    }

    /// Hides the view.
    func hide() {
        transition(visible: false)
    }

    /// Toggles the transitioner.
    func toggle() {
        transition(visible: !isVisible)
    }

}

// MARK: - Private Functions
private extension BottomTransitionViewContainer {

    func setupDesign() {
        guard let superView = superView, transitionView.superview == nil else {
            return
        }

        superView.addSubview(transitionView)

        transitionView.autoPinEdge(.leading, to: .leading, of: superView)
        transitionView.autoPinEdge(.trailing, to: .trailing, of: superView)
        topTransitionViewConstraint = transitionView.autoPinEdge(.top,
                                                                 to: .bottom,
                                                                 of: superView,
                                                                 withOffset: hiddenConstant)
        superView.layoutIfNeeded()
    }

    func transition(visible: Bool) {
        guard let superView = superView, visible != isVisible else {
            return
        }

        setupDesign()
        isVisible = visible
        topTransitionViewConstraint?.constant = visible ? visibleConstant : hiddenConstant

        UIView.animate(withDuration: AnimationConstants.defaultDuration, delay: 0, options: .curveEaseInOut, animations: {
            superView.layoutIfNeeded()
        }, completion: { (_) in
            if !visible {
                self.transitionView.removeFromSuperview()
            }
        })
    }

}
