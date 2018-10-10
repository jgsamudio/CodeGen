//
//  EventWithFeeView.swift
//  TheWing
//
//  Created by Luna An on 5/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EventWithFeeView: BuildableView {
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
    
    // MARK: - Public Properties
    
        let label = UILabel(numberOfLines: 0)
        addSubview(label)
        let gutter = EventWithFeeView.gutter
        let insets = UIEdgeInsets(top: gutter, left: gutter, bottom: 0, right: gutter)
        label.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let separatorView = UIView.dividerView(height: 1, color: theme.colorTheme.emphasisQuaternary.withAlphaComponent(0.2))
        addSubview(separatorView)
        separatorView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 18)
        separatorView.autoPinEdge(.leading, to: .leading, of: self, withOffset: EventWithFeeView.gutter)
        separatorView.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -EventWithFeeView.gutter)
        return separatorView
    }()
    
    private lazy var feeDescriptionLabel: UILabel = {
        let label = UILabel(numberOfLines: 0)
        addSubview(label)
        label.autoSetDimension(.width, toSize: 120)
        label.autoPinEdge(.top, to: .bottom, of: separatorView, withOffset: 15)
        label.autoPinEdge(.leading, to: .leading, of: separatorView)
        label.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -26)
        return label
    }()
    
    private lazy var feeLabel: UILabel = {
        let label = UILabel()
        addSubview(label)
        label.autoAlignAxis(.horizontal, toSameAxisOf: feeDescriptionLabel)
        label.autoPinEdge(.leading, to: .trailing, of: feeDescriptionLabel, withOffset: 11)
        label.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -ViewConstants.defaultGutter)
        return label
    }()
    
    // MARK: - Constants
    
    fileprivate static let gutter: CGFloat = 24
    
    // MARK: - Public Functions
    
    /// Sets up the view with given information.
    ///
    /// - Parameters:
    ///   - title: Title.
    ///   - fee: Fee to display.
    func set(title: String, fee: String) {
        setupView(title: title, fee: fee)
    }
    
}

// MARK: - Private Functions
private extension EventWithFeeView {
    
    func setupView(title: String, fee: String) {
        backgroundColor = theme.colorTheme.invertPrimary
        setupTitle(title: title)
        setupFeeDescriptionLabel()
        setupFeeLabel(fee: fee)
    }
    
    private func setupTitle(title: String) {
        let textStyle = theme.textStyleTheme.headline4.withColor(theme.colorTheme.emphasisQuintary)
        titleLabel.setText(title, using: textStyle)
    }
    
    private func setupFeeDescriptionLabel() {
        let textStyle = theme.textStyleTheme.bodySmall
        let description = "EVENT_FEE_INFORMATION".localized(comment: "Event fee information")
        feeDescriptionLabel.setText(description, using: textStyle)
    }
    
    private func setupFeeLabel(fee: String) {
        let textStyle = theme.textStyleTheme.displayHuge.withColor(theme.colorTheme.primary)
        feeLabel.setText(fee, using: textStyle)
    }
    
}
