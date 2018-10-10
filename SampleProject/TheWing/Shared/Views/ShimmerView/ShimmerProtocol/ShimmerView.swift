//
//  ShimmerView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 10/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class ShimmerView {

    // MARK: - Public Properties

    /// View to add a shimmer to.
    let view: UIView

    // MARK: - Private Properties

    /// Style of the shimmer.
    private let style: ShimmerStyle

    /// Height of the shimmer.
    private let height: CGFloat?

    /// Original text color.
    private var textColor: UIColor?

    /// Original background color.
    private var backgroundColor: UIColor?

    // MARK: - Initialization

    /// Default initializer of the shimmer label.
    ///
    /// - Parameters:
    ///   - label: Label to apply the shimmer to.
    ///   - style: Shimmer style, defaults to a full shimmer.
    ///   - height: height of the shimmer view, if nil will match height of the label.
    init(_ view: UIView, style: ShimmerStyle = .full, height: CGFloat? = nil) {
        self.view = view
        self.style = style
        self.height = height
    }

}

// MARK: - ShimmerViewDelegate
extension ShimmerView: ShimmerViewDelegate {

    // MARK: - Public Functions
    
    func prepareForShimmer() {
        view.isHidden = false
        if let backgroundColor = view.backgroundColor {
            self.backgroundColor = backgroundColor
            view.backgroundColor = backgroundColor.withAlphaComponent(0)
        }

        prepareLabelForShimmer()
        prepareButtonForShimmer()
    }

    func willRemoveShimmer() {
        if let backgroundColor = backgroundColor {
            view.backgroundColor = backgroundColor.withAlphaComponent(1)
        }

        willRemoveShimmerForLabel()
        willRemoveShimmerForButton()
    }

    func addShimmerView(withColor shimmerColor: UIColor) {
        let containerView = ShimmerContainerViewBuilder.build(style: style, backgroundColor: shimmerColor)
        view.addSubview(containerView)

        containerView.autoAlignAxis(.horizontal, toSameAxisOf: view)
        containerView.autoPinEdge(.leading, to: .leading, of: view)

        if let height = height {
            containerView.autoSetDimension(.height, toSize: height)
        } else {
            containerView.autoMatch(.height, of: view)
        }

        switch style {
        case .custom(let width):
            containerView.autoSetDimension(.width, toSize: width)
            NSLayoutConstraint.autoSetPriority(.defaultHigh) {
                containerView.autoPinEdge(.trailing, to: .trailing, of: view)
            }
        default:
            if let widthMultiplier = style.widthMultiplier {
                containerView.autoMatch(.width, to: .width, of: view, withMultiplier: widthMultiplier)
            }
        }
    }

}

// MARK: - Private Functions
private extension ShimmerView {

    func prepareButtonForShimmer() {
        guard let button = view as? UIButton else {
            return
        }
        button.titleLabel?.layer.opacity = 0
        button.isHidden = false
    }

    func willRemoveShimmerForButton() {
        guard let button = view as? UIButton else {
            return
        }
        button.titleLabel?.layer.opacity = 1
    }

    func prepareLabelForShimmer() {
        guard let label = view as? UILabel else {
            return
        }

        if let textColor = label.textColor {
            label.textColor = textColor.withAlphaComponent(0)
            self.textColor = textColor
        }

        label.isHidden = false
        if label.text?.isEmpty ?? true {
            label.text = " "
        }
    }

    func willRemoveShimmerForLabel() {
        guard let label = view as? UILabel, let textColor = textColor else {
            return
        }
        label.textColor = textColor.withAlphaComponent(1)
    }

}
