//
//  EmptyStateSectionView.swift
//  TheWing
//
//  Created by Luna An on 4/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Empty state section view.
final class EmptyStateSectionView: BuildableView {
    
    // MARK: - Private Properties
    
    private weak var delegate: EmptyStateViewDelegate?
    
    private var type: EmptyStateViewType
    
    private lazy var iconImageView: UIImageView = {
    
    // MARK: - Public Properties
    
        let imageView = UIImageView(image: #imageLiteral(resourceName: "add_button"))
        imageView.autoSetDimensions(to: CGSize(width: 21, height: 21))
        return imageView
    }()
    
    private lazy var titleLabel = UILabel()
    
    private lazy var descriptionLabel = UILabel(numberOfLines: 2)

    // MARK: - Initialization
    
    init(theme: Theme, type: EmptyStateViewType, delegate: EmptyStateViewDelegate?) {
        self.type = type
        self.delegate = delegate
        super.init(theme: theme)
        setupView()
        setupGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Functions
private extension EmptyStateSectionView {
    
    func setupView() {
        backgroundColor = theme.colorTheme.invertTertiary
        setupIcon()
        setupTitleLabel()
        setupDescriptionLabel()
    }
    
    private func setupIcon() {
        addSubview(iconImageView)
        iconImageView.autoPinEdge(.top, to: .top, of: self, withOffset: 15)
        iconImageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: ViewConstants.defaultGutter)
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        let titleTextStyle = theme.textStyleTheme.headline3.withColor(theme.colorTheme.emphasisPrimary)
        titleLabel.setText(type.title ?? "", using: titleTextStyle)
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: iconImageView, withOffset: -2)
        titleLabel.autoPinEdge(.leading, to: .trailing, of: iconImageView, withOffset: 11)
        titleLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -ViewConstants.defaultGutter)
    }
    
    private func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        let descriptionTextStyle = theme.textStyleTheme.bodySmall.withColor(theme.colorTheme.tertiary)
        descriptionLabel.setText(type.description ?? "", using: descriptionTextStyle)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 12)
        descriptionLabel.autoPinEdge(.leading, to: .leading, of: titleLabel)
        descriptionLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -ViewConstants.defaultGutter)
        descriptionLabel.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -28)
    }

    private func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewSelected))
        addGestureRecognizer(gesture)
    }

    @objc private func viewSelected() {
        delegate?.emptyStateSelected(type: type)
    }

}
