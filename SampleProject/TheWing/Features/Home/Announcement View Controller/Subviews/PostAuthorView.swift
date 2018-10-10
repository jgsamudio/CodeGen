//
//  PostAuthorView.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class PostAuthorView: BuildableView {

    // MARK: - Private Properties

    private lazy var nameLabel: UILabel = {
    
    // MARK: - Public Properties
    
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.autoSetDimensions(to: CGSize(width: 60, height: 60))
        imageView.image = #imageLiteral(resourceName: "by_the_wing_icon")
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var timeLabel = UILabel()

    // MARK: - Constants

    private static let verticalSpacing: CGFloat = 6
    
    private static let horizontalSpacing: CGFloat = 16

    // MARK: - Initialization

    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Sets name and time labels with given strings.
    ///
    /// - Parameters:
    ///   - name: Name label.
    ///   - time: Time label.
    func set(name: String, time: String) {
        nameLabel.setMarkdownText("**\(name)**", using: theme.textStyleTheme.bodySmallSpread)
        timeLabel.setText(time.uppercased(), using: theme.textStyleTheme.subheadlineBig.withColor(theme.colorTheme.tertiary))
    }
    
    /// Sets image view with image from URL.
    ///
    /// - Parameter url: Image url.
    func setImage(url: URL) {
        imageView.loadImage(from: url)
    }
    
}

// MARK: - Private Functions
private extension PostAuthorView {
    
    func setupView() {
        setupImageView()
        setupNameLabel()
        setupTimeLabel()
    }
    
    func setupImageView() {
        addSubview(imageView)
        imageView.autoPinEdge(toSuperviewEdge: .top)
        imageView.autoPinEdge(toSuperviewEdge: .leading, withInset: ViewConstants.defaultGutter)
    }
    
    func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: PostAuthorView.verticalSpacing)
        nameLabel.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: PostAuthorView.horizontalSpacing)
        nameLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: ViewConstants.defaultGutter)
    }
    
    func setupTimeLabel() {
        addSubview(timeLabel)
        timeLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: PostAuthorView.verticalSpacing)
        timeLabel.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: PostAuthorView.horizontalSpacing)
        timeLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: PostAuthorView.horizontalSpacing)
    }
    
}
