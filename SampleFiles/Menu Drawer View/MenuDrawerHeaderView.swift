//
//  MenuDrawerHeaderView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

// HELLO WORLD
// HELLO WORLD
final class MenuDrawerHeaderView: BuildableView {
    
    // MARK: - Public Properties
    
    /// Updates the profile image.
    var profileImageURLString: String? {
        didSet {
            configureProfileImage(profileImageURLString: profileImageURLString)
        }
    }
    
    private(set) lazy var profileImageView: DoubleBorderedImageView = {
        let imageView = DoubleBorderedImageView(theme: theme)
        imageView.autoSetDimensions(to: MenuDrawerHeaderView.profileImageSize)
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.backgroundColor = theme.colorTheme.emphasisSecondary
        imageView.cornerRadius = MenuDrawerHeaderView.profileImageSize.height / 2
        return imageView
    }()

    // MARK: - Private Properties

    private let profileLabel = UILabel()

    // MARK: - Constants

    fileprivate static let buttonSize: CGFloat = 67
    fileprivate static let verticalPadding: CGFloat = 18
    fileprivate static let profileImageSize = CGSize(width: 52, height: 52)

    // MARK: - Initialization

    override init(theme: Theme) {
        super.init(theme: theme)
        configureView(theme: theme)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Functions
private extension MenuDrawerHeaderView {

    func configureView(theme: Theme) {
        backgroundColor = theme.colorTheme.primary
        setupProfileButton(theme: theme)
        setupLabel(theme: theme)
        addDividerView(leadingOffset: ViewConstants.profileDrawerInset,
                       color: theme.colorTheme.invertTertiary.withAlphaComponent(0.1))
    }

    func setupProfileButton(theme: Theme) {
        addSubview(profileImageView)

        profileImageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: ViewConstants.profileDrawerInset)
        profileImageView.autoPinEdge(.top, to: .top, of: self, withOffset: MenuDrawerHeaderView.verticalPadding)
        profileImageView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -MenuDrawerHeaderView.verticalPadding)
        profileImageView.autoSetDimensions(to: MenuDrawerHeaderView.profileImageSize)
        
        profileImageView.isAccessibilityElement = true
        profileImageView.accessibilityLabel = "MY_PROFILE".localized(comment: "My Profile")
        profileImageView.accessibilityTraits = UIAccessibilityTraitButton
    }

    func setupLabel(theme: Theme) {
        addSubview(profileLabel)
        profileLabel.autoAlignAxis(.horizontal, toSameAxisOf: profileImageView)
        profileLabel.autoPinEdge(.leading, to: .trailing, of: profileImageView, withOffset: 15)

        let textStyle = theme.textStyleTheme.bodyLarge.withColor(theme.colorTheme.secondary)
        profileLabel.setText("MY_PROFILE".localized(comment: "My Profile"), using: textStyle.withLineSpacing(0))
        profileLabel.accessibilityTraits = UIAccessibilityTraitButton
    }
    
    func configureProfileImage(profileImageURLString: String?) {
        guard let urlString = profileImageURLString, let url = URL(string: urlString) else {
            return
        }
        
        profileImageView.setImage(url: url)
    }

}
