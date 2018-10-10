//
//  StylizedButton.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Button that allows custom styles to be applied.
final class StylizedButton: UIButton {

	// MARK: - Public Properties

    // MARK: - Public Properties
    
    override var isHighlighted: Bool {
        didSet {
            let stateStyle = isHighlighted ? buttonStyle?.highlightedStyle : buttonStyle?.normalStyle
            setupButton(stateStyle: stateStyle)
        }
    }

    override var isSelected: Bool {
        didSet {
            let stateStyle = isSelected ? buttonStyle?.selectedStyle : buttonStyle?.normalStyle
            setupButton(stateStyle: stateStyle)
        }
    }

    override var isEnabled: Bool {
        didSet {
            let stateStyle = isEnabled ? buttonStyle?.normalStyle : buttonStyle?.disabledStyle
            setupButton(stateStyle: stateStyle)
        }
    }

    /// Style of the button.
    var buttonStyle: ButtonStyle? {
        didSet {
            setupButton(stateStyle: buttonStyle?.normalStyle)
        }
    }

	// MARK: - Private Properties

    // MARK: - Private Properties
    
    private var currentStyleState: ButtonStateStyle?
    private var heightConstraint: NSLayoutConstraint?
    private var title: String?
    private var isAnimating = false

    private var delayedAnimation: (() -> Void)?
    private var delayedAnimationDuration: TimeInterval = 1

    private lazy var loadingIndicator: LoadingIndicator = {
        let loadingIndicator = LoadingIndicator()
        addSubview(loadingIndicator)
        loadingIndicator.autoPinEdgesToSuperviewEdges()
        return loadingIndicator
    }()

    // MARK: - Constants

    private var height: CGFloat {
        return DeviceMeasurement.value(smallDevices: 44, regularDevices: 44, largeDevices: 50)
    }

	// MARK: - Initialization

    // MARK: - Initialization
    
    init(buttonStyle: ButtonStyle? = nil, title: String = "", titleEdgeInsets: UIEdgeInsets? = nil) {
        self.buttonStyle = buttonStyle
        super.init(frame: .zero)
        if let titleEdgeInsets = titleEdgeInsets {
            self.titleEdgeInsets = titleEdgeInsets
        }
        self.title = title
        setupButton(stateStyle: buttonStyle?.normalStyle)
        setupDesign()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDesign()
    }

	// MARK: - Public Functions

    // MARK: - Public Functions
    
    override func setTitle(_ title: String?, for state: UIControlState = .normal) {
        self.title = title

        if let title = title, let textStyle = currentStyleState?.titleTextStyle {
            setTitleText(title, using: textStyle, forState: state)
        } else {
            super.setTitle(title, for: state)
        }
    }

    /// Animates the title with the given parameters.
    ///
    /// - Parameters:
    ///   - title: Title of the button.
    ///   - state: Control state of the button.
    func animateTitle(_ title: String?, for state: UIControlState = .normal) {
        if isAnimating {
            delayedAnimation = nil
        }

        UIView.transition(with: self,
                          duration: AnimationConstants.defaultDuration,
                          options: .transitionCrossDissolve,
                          animations: {
            self.setTitle(title, for: state)
        }) { [weak self] (_) in
            self?.animateDelayedAnimation()
        }
    }

    /// Shows the loading indicator with the parameter provided.
    ///
    /// - Parameter loading: Determines if there is a network request occuring.
    func isLoading(loading: Bool) {
        isUserInteractionEnabled = !loading
        
        UIView.animate(withDuration: AnimationConstants.loadingIndicatorDuration, animations: {
            self.titleLabel?.alpha = loading ? 0 : 1
        })

        loadingIndicator.isLoading(loading: loading)
    }

    /// Sets the height with the given parameter.
    ///
    /// - Parameter height: Height of the button.
    func set(height: CGFloat) {
        heightConstraint?.constant = height
        layoutIfNeeded()
    }

    /// Sets the delayed animation.
    ///
    /// - Parameters:
    ///   - duration: Duration of the delay.
    ///   - delayedAnimation: Animation to delay.
    func setDelayedAnimation(duration: TimeInterval = 1, delayedAnimation: (() -> Void)?) {
        self.delayedAnimation = delayedAnimation
        delayedAnimationDuration = duration
    }

}

// MARK: - Private Functions
private extension StylizedButton {

    func setupDesign() {
        NSLayoutConstraint.autoSetPriority(.defaultHigh) {
            heightConstraint = autoSetDimension(.height, toSize: height)
        }
    }

    func setupButton(stateStyle: ButtonStateStyle?) {
        currentStyleState = stateStyle
        guard let style = stateStyle else {
            return
        }

        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        setTitle(title, for: state)
        set(border: style.border)
    }

    func animateDelayedAnimation() {
        guard delayedAnimation != nil else {
            isAnimating = false
            return
        }

        isAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + delayedAnimationDuration) { [weak self] in
            self?.isAnimating = false
            guard let delayedAnimation = self?.delayedAnimation else {
                return
            }
            delayedAnimation()
            self?.delayedAnimation = nil
        }
    }

    private func set(border: Border?) {
        if let border = border {
            layer.borderColor = border.color.cgColor
            layer.borderWidth = border.width
        } else {
            layer.borderWidth = 0
            layer.borderColor = nil
        }
    }
    
}
