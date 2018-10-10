//
//  EventDetailHeaderView.swift
//  TheWing
//
//  Created by Luna An on 4/25/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EventDetailHeaderView: BuildableView {
    
    // MARK: - Private Properties
    
    private lazy var stackView: UIStackView = {
    
    // MARK: - Public Properties
    
        let stackView = UIStackView(arrangedSubviews: [],
                                    axis: .vertical,
                                    distribution: .fill,
                                    alignment: .fill,
                                    spacing: 18)
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var eventTitleLabel = UILabel(numberOfLines: 0)
    
    private lazy var topicFormatLabel = UILabel(numberOfLines: 0)
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "empty_badge")
        imageView.autoSetDimension(.height, toSize: 75)
        return imageView
    }()
    
    private lazy var whiteSpace: UIView = {
        let whiteSpace = UIView()
        whiteSpace.backgroundColor = theme.colorTheme.invertTertiary
        whiteSpace.autoSetDimension(.height, toSize: 37.5)
        addSubview(whiteSpace)
        return whiteSpace
    }()
    
    private lazy var loadingIndicator: LoadingIndicator = {
        let indicator = LoadingIndicator(activityIndicatorViewStyle: .gray)
        addSubview(indicator)
        return indicator
    }()

    private lazy var shimmerStackView: UIStackView = {
        let shimmerHeight: CGFloat = 13
        let shimmerColor = colorTheme.secondary
        
        let titleShimmer = ShimmerContainer.generateShimmerView(backgroundColor: shimmerColor)
        let subtitleShimmer = ShimmerContainer.generateShimmerView(backgroundColor: shimmerColor)
        let formatShimmer = ShimmerContainer.generateShimmerView(backgroundColor: shimmerColor)
        let stackView = UIStackView(arrangedSubviews: [titleShimmer,
                                                       UIView.dividerView(height: 16),
                                                       subtitleShimmer,
                                                       UIView.dividerView(height: 30),
                                                       formatShimmer],
                                    axis: .vertical,
                                    distribution: .fill,
                                    alignment: .center)
        
        titleShimmer.autoSetDimension(.width, toSize: UIScreen.width - (2 * EventDetailHeaderView.gutter))
        titleShimmer.autoSetDimension(.height, toSize: shimmerHeight)
                
        subtitleShimmer.autoMatch(.width, to: .width, of: titleShimmer, withMultiplier: 0.5, relation: .equal)
        subtitleShimmer.autoSetDimension(.height, toSize: shimmerHeight)

        formatShimmer.autoMatch(.width, to: .width, of: subtitleShimmer)
        formatShimmer.autoSetDimension(.height, toSize: shimmerHeight)
        
        return stackView
    }()
    
    // MARK: - Constants
    
    private static let gutter: CGFloat = 45
    
    // MARK: - Initialization

    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets up the Event Details Page header with given information.
    ///
    /// - Parameters:
    ///   - title: The event title.
    ///   - headline: The event headline.
    func setup(title: String, headline: String) {
        let titleTextStyle = theme.textStyleTheme.headline1
                            .withColor(theme.colorTheme.emphasisQuintary)
                            .withAlignment(.center)
        eventTitleLabel.setText(title, using: titleTextStyle)
        
        let topicFormatTextStyle = theme.textStyleTheme.bodySmallSpread.withAlignment(.center)
        topicFormatLabel.setMarkdownText(headline, using: topicFormatTextStyle)
    }
    
    /// Sets up the icon image with the given url string.
    ///
    /// - Parameter imageURL: The icon image url.
    func setIcon(with imageURL: URL) {
        iconImageView.loadImage(from: imageURL)
    }
    
    /// Sets the icon image view with given image.
    ///
    /// - Parameter image: UIImage.
    func setIcon(with image: UIImage) {
        let fadeAnimation = CABasicAnimation(keyPath: "contents")
        fadeAnimation.fromValue = iconImageView.image
        fadeAnimation.toValue = image
        fadeAnimation.duration = 0.5
        iconImageView.layer.add(fadeAnimation, forKey: "contents")
        iconImageView.image = image
    }
    
    /// Configures view for initial load if needed.
    ///
    /// - Parameter initialLoad: Configures view for initial load, if true, normal view otherwise.
    func setInitialLoad(_ initialLoad: Bool) {
        setShimmer(initialLoad)
        isLoading(initialLoad)
    }
    
    /// Sets the loading state of the badge.
    func isLoading(_ loading: Bool) {
        self.loadingIndicator.isLoading(loading: loading)
        if loading {
            iconImageView.image = #imageLiteral(resourceName: "empty_badge")
        }
    }
    
}

// MARK: - Private Functions
private extension EventDetailHeaderView {
    
    func setupDesign() {
        backgroundColor = theme.colorTheme.invertPrimary
        setupWhiteSpace()
        setupStackView()
        setupLoadingIndicator()
    }
    
    func setupStackView() {
        let insets = UIEdgeInsets(top: 18,
                                  left: EventDetailHeaderView.gutter,
                                  bottom: 0,
                                  right: EventDetailHeaderView.gutter)
        stackView.autoPinEdgesToSuperviewEdges(with: insets)
        stackView.addArrangedSubview(eventTitleLabel)
        stackView.addArrangedSubview(topicFormatLabel)
        stackView.addArrangedSubview(iconImageView)
    }
    
    func setupWhiteSpace() {
        whiteSpace.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    func setupLoadingIndicator() {
        loadingIndicator.autoMatch(.width, of: iconImageView)
        loadingIndicator.autoMatch(.height, of: iconImageView)
        loadingIndicator.autoAlignAxis(.horizontal, toSameAxisOf: iconImageView)
        loadingIndicator.autoAlignAxis(.vertical, toSameAxisOf: iconImageView)
    }
    
    func setShimmer(_ shimmer: Bool) {
        guard shimmer else {
            shimmerStackView.removeFromSuperview()
            if eventTitleLabel.superview == nil {
                stackView.insertArrangedSubview(eventTitleLabel, at: 0)
            }
            if topicFormatLabel.superview == nil {
                stackView.insertArrangedSubview(topicFormatLabel, at: 1)
            }
            return
        }
        
        eventTitleLabel.removeFromSuperview()
        topicFormatLabel.removeFromSuperview()
        stackView.insertArrangedSubview(shimmerStackView, at: 0)
    }
    
}
