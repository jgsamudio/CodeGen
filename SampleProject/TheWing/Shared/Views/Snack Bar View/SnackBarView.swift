//
//  SnackBarView.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class SnackBarView: BuildableView {

    // MARK: - Public Properties

    weak var delegate: SnackBarDelegate?

    /// Flag to determine if the view is shown. Called before animation is completed.
    var displayed: Bool = false {
        didSet {
            delegate?.updateStatusBar()
        }
    }
    
    var message: String? {
        get {
            return messageLabel.text
        } set {
            messageLabel.setText(newValue ?? "", using: textStyle)
        }
    }
    
    // MARK: - Private Properties

    private var messageLabel = UILabel(numberOfLines: 0)
    
    private lazy var textStyle = textStyleTheme.bodySmall.withColor(colorTheme.invertTertiary)

    private var dismissButton = UIButton()
    
    private var separator = UIView()
    
    private var horizontalConstraints: [NSLayoutConstraint] = []
    
    // MARK: - Initialization

    /// Instantiates a snack bar view with given message and theme.
    ///
    /// - Parameters:
    ///   - message: Message to display in the snack bar.
    ///   - theme: Theme.
    init(message: String, theme: Theme) {
        super.init(theme: theme)
        setupDesign()
        messageLabel.setText(message, using: textStyle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions

    /// Displays the snack bar view on top of the topmost view controller.
    ///
    /// - Parameter animated: If true, animates reveal, does not if false.
    func show(animated: Bool) {
        guard superview == nil else {
            return
        }
        
        guard let superView = UIApplication.shared.keyWindow else {
            return
        }

        displayed = true
        superView.addSubview(self)
        horizontalConstraints = [autoPinEdge(toSuperviewEdge: .leading),
                       autoPinEdge(toSuperviewEdge: .trailing)]
        frame.origin.y = superView.frame.origin.y - self.bounds.height
        
        if animated {
            layoutIfNeeded()
            UIView.animate(withDuration: AnimationConstants.defaultDuration,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .curveEaseOut,
                           animations: {
                            self.frame.origin.y = superView.frame.origin.y
            }, completion: nil)
        } else {
            self.frame.origin.y = superView.frame.origin.y
        }
    }
    
    /// Dismisses the snack bar view from its superview.
    ///
    /// - Parameter animated: If true, animates dismissal, does not if false.
    func dismiss(animated: Bool) {
        guard let superView = superview else {
            return
        }
        
        func resetView() {
            superView.removeConstraints(horizontalConstraints)
            removeFromSuperview()
            horizontalConstraints = []
        }

        displayed = false
        if animated {
            UIView.animate(withDuration: AnimationConstants.defaultDuration,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .curveEaseIn,
                           animations: {
                self.frame.origin.y = superView.frame.origin.y - self.bounds.height
            }) { (_) in
                resetView()
            }
        } else {
            resetView()
        }
    }
    
}

// MARK: - Private Functions
private extension SnackBarView {
    
    func setupDesign() {
        backgroundColor = colorTheme.primary

        addSubview(messageLabel)
        let topInset = DeviceMeasurement.value(smallDevices: 42, regularDevices: 42, largeDevices: 46)
        let insets = UIEdgeInsets(top: topInset, left: 24, bottom: 22, right: 24)
        messageLabel.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .trailing)

        addSubview(dismissButton)
        dismissButton.setImage(#imageLiteral(resourceName: "white_close_button"), for: .normal)
        let dismissTopInset = DeviceMeasurement.value(smallDevices: 33, regularDevices: 33, largeDevices: 37)
        dismissButton.autoPinEdge(.top, to: .top, of: self, withOffset: dismissTopInset)
        dismissButton.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -9)
        dismissButton.autoPinEdge(.leading, to: .trailing, of: messageLabel, withOffset: 12)
        dismissButton.autoSetDimensions(to: CGSize(width: 46, height: 46))
        dismissButton.addTarget(self, action: #selector(dismissButtonSelected), for: .touchUpInside)

        addSubview(separator)
        separator.backgroundColor = colorTheme.emphasisQuintary
        separator.autoSetDimension(.height, toSize: 1)
        separator.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }

    @objc func dismissButtonSelected() {
        dismiss(animated: true)
    }
    
}
