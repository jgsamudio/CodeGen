//
//  ScrollViewShrinkableTopView.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/13/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// View that can be added atop a scroll view (see: `attach(to:)`) and animates with the iOS 11 resizable nav bar.
final class ScrollViewShrinkableTopView: UIView {

    // MARK: - Private Properties
    
    @IBOutlet private weak var contentLabel: StyleableLabel!

    @IBOutlet private weak var collapsedContentLabel: StyleableLabel!

    @IBOutlet private weak var button: StyleableButton!

    @IBOutlet private weak var labelHeightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var labelTopConstraint: NSLayoutConstraint!

    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!

    // MARK: - Public Properties
    
    /// Action to be performed when tapping the action button.
    var callback: () -> Void = {}

    /// Title for the action button on the right.
    var buttonTitle: String? {
        didSet {
            button.setTitle(buttonTitle, for: .normal)
        }
    }

    /// Content for the expanded view state.
    var content: String? {
        didSet {
            contentLabel.text = content
            layoutIfNeeded()
        }
    }

    /// Content for the collapsed view state.
    var collapsedContent: String? {
        didSet {
            collapsedContentLabel.text = collapsedContent
            layoutIfNeeded()
        }
    }

    /// Inset that is added below the grey bottom bar and shrunk when the user scrolls down the table view.
    var additionalInset: CGFloat = 0 {
        didSet {
            bottomConstraint?.constant = 16 + additionalInset
        }
    }

    private weak var attachedScrollView: UIScrollView?
    private weak var attachedScrollViewTopConstraint: NSLayoutConstraint?
    private var attachedScrollViewTopConstant: CGFloat = 0

    private weak var topConstraint: NSLayoutConstraint?

    // MARK: - Public Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()

        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentOffsetChanged(contentOffset: attachedScrollView?.contentOffset ?? .zero)
    }

    /// Attaches `self` to the given scroll view, pinning `self` to the top of that scroll view.
    ///
    /// - Parameter scrollView: Scroll view to attach `self` to.
    func attach(to scrollView: UIScrollView, scrollViewTopConstraint: NSLayoutConstraint) {
        attachedScrollView = scrollView
        attachedScrollViewTopConstraint = scrollViewTopConstraint
        attachedScrollViewTopConstant = scrollViewTopConstraint.constant
        scrollView.superview?.insertSubview(self, aboveSubview: scrollView)

        let constraints = pin(to: scrollView, top: 0, leading: 0, bottom: nil, trailing: 0)
        topConstraint = constraints.first(where: { (constraint) -> Bool in
            constraint.firstAttribute == NSLayoutAttribute.top
        })

        bottomConstraint.constant = 16 + additionalInset
    }

    private func contentOffsetChanged(contentOffset: CGPoint) {
        let dy = contentOffset.y

        translateIntoPlace(dy: dy)
        adjustAlpha(dy: dy, beginningAnimation: 0, endingAnimation: 20)
        adjustLabelTranslate(dy: dy, transitionArea: 20)
        adjustLabelConstraint(dy: dy, transitionArea: 20)

        attachedScrollViewTopConstraint?.constant = attachedScrollViewTopConstant + bounds.height
        topConstraint?.constant = -bounds.height
    }

    private func translateIntoPlace(dy: CGFloat) {
        if dy < 0 {
            transform = CGAffineTransform(translationX: 0, y: -dy - (attachedScrollView?.contentInset.top ?? 0))
        } else {
            transform = .identity
        }
    }

    private func adjustAlpha(dy: CGFloat, beginningAnimation: CGFloat, endingAnimation: CGFloat) {
        let fadeOutEnd: CGFloat = 0.5
        let fadeInStart: CGFloat = 0.39
        let fadeOutArea = (endingAnimation - beginningAnimation) * fadeOutEnd
        let fadeInArea = (endingAnimation - beginningAnimation) * fadeInStart
        let alpha1 = 1 - (dy.clamp(minimum: beginningAnimation, maximum: beginningAnimation + fadeOutArea) - beginningAnimation)
            / fadeOutArea
        let alpha2 = (dy.clamp(minimum: beginningAnimation + fadeInArea, maximum: endingAnimation) - fadeInArea - beginningAnimation)
            / fadeInArea

        contentLabel.alpha = alpha1
        collapsedContentLabel.alpha = alpha2
    }

    private func adjustLabelTranslate(dy: CGFloat, transitionArea: CGFloat) {
        let clamped = dy.clamp(minimum: 0, maximum: transitionArea)
        let translate = clamped
        let inverse = clamped - transitionArea

        contentLabel.transform = CGAffineTransform(translationX: 0, y: -translate / 2)
        collapsedContentLabel.transform = CGAffineTransform(translationX: 0, y: -inverse / 2)
    }

    private func adjustLabelConstraint(dy: CGFloat, transitionArea: CGFloat) {
        let clamped = dy.clamp(minimum: 0, maximum: transitionArea)
        let alpha = clamped / transitionArea
        let inverse = 1 - alpha

        let contentHeight = contentLabel.sizeThatFits(UILayoutFittingCompressedSize).height
        let collapsedContentHeight = collapsedContentLabel.sizeThatFits(UILayoutFittingCompressedSize).height

        labelHeightConstraint.constant = alpha * collapsedContentHeight + inverse * max(contentHeight, collapsedContentHeight + 14)
        labelTopConstraint.constant = alpha * 14
        bottomConstraint.constant = 16 + additionalInset - (dy * 2).clamp(minimum: 0, maximum: additionalInset)
    }

    @objc private func didTapButton() {
        callback()
    }

}

// MARK: - UIScrollViewDelegate
extension ScrollViewShrinkableTopView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffsetChanged(contentOffset: scrollView.contentOffset)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let suggestedOffset = targetContentOffset.pointee

        if suggestedOffset.y < 20 {
            targetContentOffset.pointee.y = 0
        }
    }

}
