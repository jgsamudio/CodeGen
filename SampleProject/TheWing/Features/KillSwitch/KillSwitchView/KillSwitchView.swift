//
//  KillSwitchView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 9/5/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class KillSwitchView: BuildableView {

    // MARK: - Private Properties

    private let wingImageView = UIImageView(image: #imageLiteral(resourceName: "killswitch_header_icon"))

    private var labelPadding: CGFloat {
        return UIScreen.width * 0.085
    }

    private lazy var centerImageView: UIImageView = {
    
    // MARK: - Public Properties
    
        let imageView = UIImageView(image: #imageLiteral(resourceName: "killswitch_be_right_back_icon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
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
private extension KillSwitchView {

    func setupView() {
        backgroundColor = colorTheme.invertPrimary

        addSubview(wingImageView)
        wingImageView.autoAlignAxis(.vertical, toSameAxisOf: self)
        wingImageView.autoPinEdge(.top, to: .top, of: self, withOffset: UIScreen.height * 0.088)
        wingImageView.autoMatch(.height, to: .height, of: self, withMultiplier: 0.1)
        wingImageView.autoMatch(.width, to: .height, of: wingImageView, withMultiplier: 1.219)

        addSubview(centerImageView)
        centerImageView.autoAlignAxis(.vertical, toSameAxisOf: self, withOffset: UIScreen.width * 0.013)
        centerImageView.autoPinEdge(.top, to: .top, of: self, withOffset: UIScreen.height * 0.241)
        centerImageView.autoMatch(.width, to: .width, of: self, withMultiplier: 0.746)
        centerImageView.autoMatch(.width, to: .height, of: centerImageView, withMultiplier: 0.979)

        addSubview(descriptionLabel)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: centerImageView, withOffset: UIScreen.height * 0.124)
        descriptionLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: labelPadding)
        descriptionLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -labelPadding)
    }

}
