//
//  SuperMatchView.swift
//  TheWing
//
//  Created by Luna An on 8/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class SuperMatchView: BuildableView {
    
    // MARK: - Public Properties

    /// The color of the match view. Updated when the view is loading.
    var matchViewColor: UIColor? {
        didSet {
            speechBubbleImageView.tintColor = matchViewColor
            containerView.backgroundColor = matchViewColor
        }
    }

    /// Determines if the view is loading.
    var isLoading: Bool = false {
        didSet {
            descriptionLabel.isHidden = isLoading
            iconImageView.isHidden = isLoading
            let shimmerColor = colorTheme.emphasisQuaternary.withAlphaComponent(0.1)
            speechBubbleImageView.tintColor = isLoading ? shimmerColor : matchViewColor
            containerView.backgroundColor = isLoading ? shimmerColor : matchViewColor
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var speechBubbleImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "supermatch_point_view").withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "supermatch_icon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var descriptionLabel = UILabel(numberOfLines: 0)

    private var containerView = UIView()
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    
    /// Sets up view with description.
    ///
    /// - Parameter description: Description text to display.
    func setup(description: String?) {
        guard let description = description, description.isValidString else {
            isHidden = true
            return
        }
        
        isHidden = false
        let textStyle = textStyleTheme.bodyTiny.withColor(colorTheme.primary)
        descriptionLabel.setText(description, using: textStyle)
    }

}

// MARK: - Private Functions
private extension SuperMatchView {
    
    func setupView() {
        addSubview(speechBubbleImageView)
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(descriptionLabel)

        NSLayoutConstraint.autoSetPriority(.defaultHigh) {
            autoSetDimension(.height, toSize: 40, relation: .greaterThanOrEqual)
        }

        speechBubbleImageView.autoPinEdge(.top, to: .top, of: self)
        speechBubbleImageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 16)

        containerView.autoPinEdge(.top, to: .bottom, of: speechBubbleImageView)
        containerView.autoPinEdgesToSuperviewEdges(excludingEdge: .top)

        iconImageView.autoSetDimensions(to: CGSize(width: 18, height: 18))
        iconImageView.autoAlignAxis(.horizontal, toSameAxisOf: containerView)
        iconImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 12)
        iconImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 0, relation: .greaterThanOrEqual)
        iconImageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0, relation: .greaterThanOrEqual)
        
        descriptionLabel.autoAlignAxis(.horizontal, toSameAxisOf: containerView)
        descriptionLabel.autoPinEdge(.left, to: .right, of: iconImageView, withOffset: 10)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 7, relation: .greaterThanOrEqual)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 7, relation: .greaterThanOrEqual)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
    }
    
}
