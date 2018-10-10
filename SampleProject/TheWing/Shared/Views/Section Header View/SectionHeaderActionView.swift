//
//  SectionHeaderActionView.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class SectionHeaderActionView: BuildableView {

    // MARK: - Public Properties

    /// Hides the action button container. Contains see all for home screen happenings.
    var actionContainerHidden: Bool {
        get {
            return actionContainer.isHidden
        } set {
            actionContainer.isHidden = newValue
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var titleView = SectionHeaderView(theme: theme)
    
    private lazy var actionContainer: UIView = {
        let view = UIView()
        view.autoSetDimensions(to: ViewConstants.defaultCTAButtonSize)
        view.addSubview(button)
        view.isAccessibilityElement = true
        button.autoAlignAxis(toSuperviewMarginAxis: .horizontal)
        button.autoPinEdge(toSuperviewEdge: .trailing)
        view.accessibilityTraits = UIAccessibilityTraitButton
        return view
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.isAccessibilityElement = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets up title and action views with given inputs.
    ///
    /// - Parameters:
    ///   - title: Title of section.
    ///   - buttonTitle: Button title.
    ///   - target: Button target.
    ///   - selector: Button selector.
    func setup(title: String, buttonTitle: String?, target: Any?, selector: Selector?) {
        titleView.set(title: title)
        setButton(title: buttonTitle, target: target, selector: selector)
    }

    /// Updates the section with the given information.
    ///
    /// - Parameters:
    ///   - title: Title to update.
    ///   - hideButton: Flag to hide the button.
    func updateSection(title: String, hideButton: Bool) {
        UIView.transition(with: titleView, duration: AnimationConstants.fastAnimationDuration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            self?.titleView.set(title: title)
            }, completion: nil)

        UIView.animate(withDuration: AnimationConstants.fastAnimationDuration) {
            self.button.alpha = hideButton ? 0 : 1
        }
    }
    
}

// MARK: - ShimmerProtocol
extension SectionHeaderActionView: ShimmerProtocol {

    var shimmerViews: [ShimmerView] {
        return [ShimmerView(button, style: .custom(54), height: 13)]
    }

}

// MARK: - Private Functions
private extension SectionHeaderActionView {
    
    func setupDesign() {
        addSubview(titleView)
        addSubview(actionContainer)
        actionContainer.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .leading)
        titleView.autoPinEdge(toSuperviewEdge: .leading)
        titleView.autoAlignAxis(.horizontal, toSameAxisOf: actionContainer)
    }
    
    func setButton(title: String?, target: Any?, selector: Selector?) {
        let textstyle = textStyleTheme.bodyNormal.withColor(colorTheme.emphasisPrimary)
        
        guard let title = title, let target = target, let selector = selector else {
            button.setMarkdownTitleText("", using: textstyle)
            actionContainer.removeGestureRecognizers()
            actionContainer.accessibilityLabel = nil
            return
        }
        
        button.setMarkdownTitleText("**\(title)**", using: textstyle)
        actionContainer.removeGestureRecognizers()
        actionContainer.addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
        actionContainer.accessibilityLabel = title
    }
    
}
