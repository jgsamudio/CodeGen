//
//  TabItemHeaderView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class TabItemHeaderView: AccessibilityHeaderView {

    // MARK: - Public Properties

    /// Updates the border view's hidden property.
    var borderVisible: Bool = true {
        didSet {
            borderView.isHidden = !borderVisible
        }
    }

    /// Bottom spacing of the title constraint.
    var bottomSpacing: CGFloat = TabItemHeaderView.defaultBottomSpacing {
        didSet {
            bottomTitleConstraint?.constant = -bottomSpacing
            let heightOffset = TabItemHeaderView.defaultBottomSpacing - bottomSpacing
            heightConstraint?.constant = TabItemHeaderView.defaultHeight - heightOffset
            layoutIfNeeded()
        }
    }

    weak var delegate: TabItemHeaderViewDelegate?

    // MARK: - Private Properties

    private lazy var profileImage: DoubleBorderedImageView = {
        let imageView = DoubleBorderedImageView(theme: theme)
        imageView.autoSetDimensions(to: TabItemHeaderView.profileImageSize)
        imageView.isAccessibilityElement = true
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.backgroundColor = colorTheme.emphasisSecondary
        imageView.cornerRadius = TabItemHeaderView.profileImageSize.height / 2
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfile))
        imageView.addGestureRecognizer(gesture)
        imageView.accessibilityLabel = "ACCESSIBILITY_PROFILE_MENU_TITLE".localized(comment: "Profile Menu")
        addSubview(imageView)
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        addSubview(label)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.625
        label.accessibilityTraits = UIAccessibilityTraitHeader
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        addSubview(label)
        label.accessibilityTraits = UIAccessibilityTraitHeader
        label.isHidden = true
        return label
    }()

    private lazy var borderView: UIView = {
        let border = UIView()
        border.autoSetDimension(.height, toSize: 1)
        addSubview(border)
        border.backgroundColor = theme.colorTheme.tertiary
        return border
    }()

    private var bottomTitleConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Constants

    private static let profileImageSize = CGSize(width: 36, height: 36)
    private static let gutter: CGFloat = 24
    private static let defaultBottomSpacing: CGFloat = 34
    private static let defaultHeight: CGFloat = 126

    // MARK: - Initialization

    init(title: String, subtitle: String? = nil, theme: Theme) {
        super.init(theme: theme)
        configureView(title: title, subtitle: subtitle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Enables accessibility usage for child elements.
    override func enableAccessibility() {
        profileImage.isAccessibilityElement = true
        titleLabel.isAccessibilityElement = true
        subtitleLabel.isAccessibilityElement = true
    }
    
    /// Disables accessibility usage for child elements.
    override func disableAccessibility() {
        profileImage.isAccessibilityElement = false
        titleLabel.isAccessibilityElement = false
        subtitleLabel.isAccessibilityElement = false
    }

    /// Sets the profile image of the tab bar item header view.
    ///
    /// - Parameter profileImage: Image to set.
    override func set(profileImage: UIImage) {
        self.profileImage.image = profileImage
    }
    
    /// Shows or hides the header items.
    ///
    /// - Parameter show: Flag to show header items or not.
    func showHeaderItems(show: Bool) {
        let alpha: CGFloat = show ? 0 : 1
        UIView.animate(withDuration: AnimationConstants.defaultDuration) {
            self.profileImage.alpha = alpha
            self.titleLabel.alpha = alpha
        }
    }
    
    /// Sets title and optional subtitle of view.
    ///
    /// - Parameters:
    ///   - title: Title of view.
    ///   - subtitle: Optional subtitle.
    func set(title: String, subtitle: String?) {
        let textStyle = textStyleTheme.displayLarge.withColor(theme.colorTheme.primary)
        titleLabel.setMarkdownText("**\(title.uppercased())**", using: textStyle.withLineBreakMode(.byTruncatingTail))
        let textColor = colorTheme.emphasisQuaternary.withAlphaComponent(0.5)
        let subtitleTextStyle = textStyleTheme.bodyTiny.withCharacterSpacing(0.7).withColor(textColor)
        subtitleLabel.setText(subtitle ?? "", using: subtitleTextStyle)
    }

}

// MARK: - Private Functions
private extension TabItemHeaderView {

    func configureView(title: String, subtitle: String?) {
        backgroundColor = colorTheme.invertTertiary
        heightConstraint = autoSetDimension(.height, toSize: TabItemHeaderView.defaultHeight)

        setupTitle(with: title)
        setupSubtitle(with: subtitle)
        setupProfileButton()
        setupBorderView()
    }

    func setupTitle(with title: String) {
        titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: TabItemHeaderView.gutter)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing,
                               withInset: TabItemHeaderView.gutter + TabItemHeaderView.profileImageSize.width + 24)
        bottomTitleConstraint = titleLabel.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -bottomSpacing)
        let textStyle = textStyleTheme.displayLarge.withColor(theme.colorTheme.primary)
        titleLabel.setMarkdownText("**\(title.uppercased())**", using: textStyle.withLineBreakMode(.byTruncatingTail))
    }
    
    func setupSubtitle(with subtitle: String?) {
        subtitleLabel.isHidden = (subtitle == nil)
        subtitleLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: TabItemHeaderView.gutter)
        subtitleLabel.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -14)
        
        let textColor = colorTheme.emphasisQuaternary.withAlphaComponent(0.5)
        let textStyle = textStyleTheme.bodyTiny.withCharacterSpacing(0.7).withColor(textColor)
        subtitleLabel.setText(subtitle ?? "", using: textStyle)
    }

    func setupProfileButton() {
        profileImage.autoAlignAxis(.horizontal, toSameAxisOf: titleLabel)
        profileImage.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -TabItemHeaderView.gutter)
    }
    
    func setupBorderView() {
        borderView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }

    @objc func didTapProfile() {
        delegate?.profileImageSelected()
    }

}
