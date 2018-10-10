//
//  ForceUpdateView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 9/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class ForceUpdateView: BuildableView {

    // MARK: - Private Properties

    private let wingImageView = UIImageView(image: #imageLiteral(resourceName: "force_update_header_icon"))

    private let titleLabel = UILabel()

    private var labelPadding: CGFloat {
        return UIScreen.width * 0.085
    }

    private lazy var centerImageView: UIImageView = {
    
    // MARK: - Public Properties
    
        let imageView = UIImageView(image: #imageLiteral(resourceName: "force_update_icon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private lazy var appStoreButton: StylizedButton = {
        let button = StylizedButton(buttonStyle: buttonStyleTheme.primaryDarkButtonStyle)
        button.addTarget(self, action: #selector(goToAppStore), for: .touchUpInside)
        let buttonText = KillSwitchLocalization.goToAppStore.uppercased()
        button.setTitle(buttonText.uppercased())
        button.set(height: 50)
        button.accessibilityLabel = buttonText
        return button
    }()

    // MARK: - Initialization

    override init(theme: Theme) {
        super.init(theme: theme, frame: CGRect(origin: .zero, size: UIScreen.size))
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Sets the user message with the given parameter.
    ///
    /// - Parameter message: Message to display to the user.
    func setUserMessage(_ message: String) {
        descriptionLabel.setText(message, using: textStyleTheme.bodyNormal.withAlignment(.center))
    }

}

// MARK: - Private Functions
private extension ForceUpdateView {

    func setupView() {
        backgroundColor = colorTheme.invertPrimary

        addSubview(wingImageView)
        wingImageView.autoAlignAxis(.vertical, toSameAxisOf: self)
        wingImageView.autoPinEdge(.top, to: .top, of: self, withOffset: UIScreen.height * 0.064)
        wingImageView.autoMatch(.height, to: .height, of: self, withMultiplier: 0.016)
        wingImageView.autoMatch(.width, to: .height, of: wingImageView, withMultiplier: 7.547)

        addSubview(centerImageView)
        centerImageView.autoAlignAxis(.vertical, toSameAxisOf: self, withOffset: UIScreen.width * 0.024)
        centerImageView.autoPinEdge(.top, to: .top, of: self, withOffset: UIScreen.height * 0.119)
        centerImageView.autoMatch(.width, to: .width, of: self, withMultiplier: 0.626)
        centerImageView.autoMatch(.width, to: .height, of: centerImageView, withMultiplier: 1.012)

        addSubview(titleLabel)
        titleLabel.autoPinEdge(.top, to: .bottom, of: centerImageView, withOffset: UIScreen.height * 0.136)
        titleLabel.autoSetDimension(.height, toSize: 26)
        titleLabel.autoAlignAxis(.vertical, toSameAxisOf: self)
        titleLabel.setText(KillSwitchLocalization.updateRequiredTitle,
                           using: textStyleTheme.headline2.withAlignment(.center).withColor(colorTheme.primary))

        addSubview(descriptionLabel)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: UIScreen.height * 0.027)
        descriptionLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: labelPadding)
        descriptionLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -labelPadding)

        addSubview(appStoreButton)
        appStoreButton.autoPinEdge(.top, to: .bottom, of: descriptionLabel, withOffset: UIScreen.height * 0.077)
        appStoreButton.autoPinEdge(.leading, to: .leading, of: self, withOffset: 56)
        appStoreButton.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -56)
    }

    @objc func goToAppStore() {
        UIApplication.shared.openAppStore()
    }

}
