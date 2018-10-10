//
//  DrawerContainerView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class DrawerContainerView: UIView {

    // MARK: - Public Properties

    /// Determines if the drawer is hidden.
    var isDrawerHidden: Bool {
        return !isUserInteractionEnabled
    }

    /// Delegate.
    weak var delegate: DrawerContainerDelegate?

    // MARK: - Private Properties
    
    private let drawerView: UIView
    private let backgroundView = UIView()
    fileprivate var leadingDrawerViewConstraint: NSLayoutConstraint?
    fileprivate var initialX: CGFloat?

    fileprivate var visibleConstant: CGFloat {
        return UIScreen.width - drawerView.frame.width
    }

    fileprivate var hiddenConstant: CGFloat {
        return UIScreen.width + drawerView.frame.width
    }

    // MARK: - Initialization

    init(drawerView: MenuDrawerView, theme: Theme) {
        self.drawerView = drawerView
        super.init(frame: .zero)
        configureView(theme: theme)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Shows the drawer.
    func show() {
        delegate?.updateStatusBarStatus()
        transition(visible: true)
    }

    /// Hides the drawer.
    func hide() {
        delegate?.updateStatusBarStatus()
        transition(visible: false)
    }
    
}

// MARK: - Private Functions
private extension DrawerContainerView {

    func configureView(theme: Theme) {
        isUserInteractionEnabled = false
        setupBackgroundView(theme: theme)
        setupDrawerView()
    }

    func setupBackgroundView(theme: Theme) {
        addSubview(backgroundView)
        backgroundView.autoPinEdgesToSuperviewEdges()

        backgroundView.alpha = 0
        backgroundView.backgroundColor = theme.colorTheme.emphasisQuintary

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        backgroundView.addGestureRecognizer(gestureRecognizer)
    }

    func setupDrawerView() {
        addSubview(drawerView)
        layoutIfNeeded()

        drawerView.autoPinEdge(.top, to: .top, of: self)
        drawerView.autoPinEdge(.bottom, to: .bottom, of: self)
        leadingDrawerViewConstraint = drawerView.autoPinEdge(.leading, to: .leading, of: self, withOffset: hiddenConstant)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanView))
        drawerView.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func didPanView(recognizer: UIPanGestureRecognizer) {
        let fingerCenter = recognizer.location(in: recognizer.view?.superview)
        let diff = max(0, fingerCenter.x - (initialX ?? 0.0))

        if recognizer.state == UIGestureRecognizerState.began {
            initialX = fingerCenter.x
        } else if recognizer.state != UIGestureRecognizerState.ended, recognizer.state != UIGestureRecognizerState.failed {
            leadingDrawerViewConstraint?.constant = visibleConstant + diff
            layoutIfNeeded()
        } else if recognizer.state == UIGestureRecognizerState.ended {
            transition(visible: !(diff > 100))
            initialX = nil
        }
    }

    @objc func didTapBackgroundView() {
        transition(visible: false)
    }

    func transition(visible: Bool) {
        if visible {
            UIApplication.shared.keyWindow?.addSubview(self)
            autoPinEdgesToSuperviewEdges()
            layoutIfNeeded()
        }
        
        isUserInteractionEnabled = visible
        leadingDrawerViewConstraint?.constant = visible ? visibleConstant : hiddenConstant
        delegate?.updateStatusBarStatus()
        
        UIView.animate(withDuration: AnimationConstants.defaultDuration, animations: {
            self.backgroundView.alpha = visible ? 0.60 : 0
            self.layoutIfNeeded()
        }, completion: { [weak self] (_) in
            if !visible {
                self?.removeFromSuperview()
            }
        })
    }

}
