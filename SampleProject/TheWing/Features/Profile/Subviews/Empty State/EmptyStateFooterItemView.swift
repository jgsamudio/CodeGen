//
//  EmptyStateFooterItemView.swift
//  TheWing
//
//  Created by Luna An on 4/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Empty state footer item view.
final class EmptyStateFooterItemView: BuildableView {
    
    // MARK: - Private Properties
    
    private weak var delegate: ProfileFooterItemDelegate?
    
    private var type: EmptyStateViewType?
    
    private lazy var iconImageView: UIImageView = {
    
    // MARK: - Public Properties
    
        let imageView = UIImageView(image: #imageLiteral(resourceName: "plus_button"))
        imageView.autoSetDimensions(to: CGSize(width: 11, height: 11))
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Initialization
    
    init(theme: Theme, delegate: ProfileFooterItemDelegate?) {
        self.delegate = delegate
        super.init(theme: theme)
        setupDesign()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions

    /// Sets the title of the empty state view.
    ///
    /// - Parameter type: Footer item type.
    func set(type: FooterItemType) {
        configureEmptyStateViewType(with: type)
        let titleTextStyle = theme.textStyleTheme.subheadlineLarge.withColor(theme.colorTheme.emphasisPrimary)
        titleLabel.setText(type.formattedText ?? "", using: titleTextStyle)
    }
    
}

// MARK: - Private Functions
private extension EmptyStateFooterItemView {
    
    func setupDesign() {
        setupIcon()
        setupTitleLabel()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewSelected)))
    }
    
    func setupIcon() {
        addSubview(iconImageView)
        iconImageView.autoPinEdge(.leading, to: .leading, of: self)
        iconImageView.autoAlignAxis(toSuperviewMarginAxis: .horizontal)
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: iconImageView, withOffset: -2)
        titleLabel.autoPinEdge(.leading, to: .trailing, of: iconImageView, withOffset: 12)
        titleLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -ViewConstants.defaultGutter)
    }
    
    func configureEmptyStateViewType(with type: FooterItemType) {
        switch type {
        case .neighborhood:
            self.type = .neighborhood
        case .birthday:
            self.type = .birthday
        case .email:
            self.type = .email
        case .starSign:
            self.type = .starSign
        default:
            break
        }
    }
    
    @objc func viewSelected() {
        guard let type = type else {
            return
        }
        
        delegate?.emptyStateSelected(type: type)
    }
    
}
