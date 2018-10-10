//
//  ProfileFooterItem.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class ProfileFooterItem: BuildableView {

    // MARK: - Private Properties
    
    private weak var delegate: ProfileFooterItemDelegate?
    
    private lazy var imageView: UIImageView = {
    
    // MARK: - Public Properties
    
        let imageView = UIImageView()
        imageView.autoSetDimensions(to: CGSize(width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var textLabel = UILabel()
    
    private lazy var emptyStateView = EmptyStateFooterItemView(theme: theme, delegate: delegate)

    private var item: FooterItemType

    // MARK: - Initialization

    init(theme: Theme, item: FooterItemType, delegate: ProfileFooterItemDelegate?) {
        self.item = item
        self.delegate = delegate
        super.init(theme: theme)
        setupView(type: item)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Functions
private extension ProfileFooterItem {

    func setupView(type: FooterItemType) {
        addSubview(imageView)
        imageView.image = type.image
        imageView.autoPinEdge(.leading, to: .leading, of: self)
        imageView.autoAlignAxis(toSuperviewMarginAxis: .horizontal)
        
        type.isEmpty ? setupEmptyView(type: type) : setupTextLabel(type: type)
        addDividerView(leadingOffset: ViewConstants.defaultGutter, color: colorTheme.tertiaryFaded)
    }
    
    func setupEmptyView(type: FooterItemType) {
        removeGestureRecognizers()
        emptyStateView.set(type: type)
        addSubview(emptyStateView)
        emptyStateView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .leading)
        emptyStateView.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: 12)
    }
    
    func setupTextLabel(type: FooterItemType) {
        addSubview(textLabel)
        textLabel.setText(type.formattedText ?? "", using: textStyleTheme.bodyNormal)
        textLabel.numberOfLines = 0
        textLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -5)
        textLabel.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: 16)
        textLabel.autoPinEdge(.top, to: .top, of: self, withOffset: 7)
        textLabel.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -9)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewSelected)))
    }

    @objc func viewSelected() {
        delegate?.viewSelected(item: item)
    }
        
}
