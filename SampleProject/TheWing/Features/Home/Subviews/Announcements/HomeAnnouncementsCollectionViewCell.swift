//
//  AnnouncementsCollectionViewCell.swift
//  TheWing
//
//  Created by Paul Jones on 7/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class HomeAnnouncementsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private lazy var mainStackView = UIStackView(arrangedSubviews: [topImageView,
                                                                    noImageSpacerView,
                                                                    middleElementsStackView,
                                                                    titleLabel,
                                                                    previewLabel],
                                                 axis: .vertical,
                                                 distribution: .fill,
                                                 alignment: .fill,
                                                 spacing: 10)
    
    private lazy var middleElementsStackView = UIStackView(arrangedSubviews: [authorCircularImageView, metadataStackView],
                                                           axis: .horizontal,
                                                           distribution: .fill,
                                                           alignment: .center,
                                                           spacing: 13)
    
    private lazy var metadataStackView = UIStackView(arrangedSubviews: [authorNameLabel, publishedTimeLabel],
                                                     axis: .vertical,
                                                     distribution: .fillEqually,
                                                     alignment: .fill)
    
    private lazy var topImageView: UIImageView = {
    
    // MARK: - Public Properties
    
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.autoSetDimension(.height, toSize: 108)
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(numberOfLines: 0)
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()
    
    private lazy var authorCircularImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.autoSetDimensions(to: CGSize(width: authorViewHeight, height: authorViewHeight))
        imageView.layer.cornerRadius = authorViewHeight/2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var noImageSpacerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.autoSetDimension(.height, toSize: 50)
        return view
    }()
    
    private var mainBackgroundView = UIView()
    
    private var authorNameLabel = UILabel()
    
    private var publishedTimeLabel = UILabel()
    
    private var previewLabel = UILabel(numberOfLines: 0)
    
    private var didSetupConstraints = false
    
    // MARK: - Constants
    
    private let gutter: CGFloat = 24
    private let authorViewHeight: CGFloat = 32
    
    // MARK: - Public Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topImageView.af_cancelImageRequest()
        authorCircularImageView.af_cancelImageRequest()
    }
    
    /// Sets the design of the view given announcement data.
    ///
    /// - Parameters:
    ///   - data: Announcement data.
    ///   - theme: Theme.
    func setup(data: AnnouncementData, theme: Theme) {
        setupDesign(theme: theme)
        authorNameLabel.setText(data.author, using: theme.textStyleTheme.captionBig)
        let color = theme.colorTheme.emphasisSecondary
        publishedTimeLabel.setText(data.timePosted.uppercased(),
                                   using: theme.textStyleTheme.captionBig.withColor(color))
        previewLabel.setText(data.description, using: theme.textStyleTheme.bodySmall)
        layer.applySketchShadow(color: theme.colorTheme.secondary, shawdowY: 7, blur: 16)
        
        if let imageURL = data.imageURL {
            topImageView.loadImage(from: imageURL)
            topImageView.isHidden = false
            noImageSpacerView.isHidden = true
        } else {
            topImageView.image = nil
            topImageView.isHidden = true
            noImageSpacerView.isHidden = false
        }
        
        if let authorImageURL = data.authorImageURL {
            authorCircularImageView.loadImage(from: authorImageURL)
        } else {
            authorCircularImageView.image = #imageLiteral(resourceName: "by_the_wing_icon")
        }
        
        if let title = data.title, !title.isEmpty {
            titleLabel.setMarkdownText("**\(title)**", using: theme.textStyleTheme.bodyLarge)
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
    }
    
}

// MARK: - Private Functions
private extension HomeAnnouncementsCollectionViewCell {
    
    func setupDesign(theme: Theme) {
        guard !didSetupConstraints else {
            return
        }
        
        addSubview(mainBackgroundView)
        mainBackgroundView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 26, left: 0, bottom: 0, right: 0))
        mainBackgroundView.backgroundColor = theme.colorTheme.invertTertiary
        mainBackgroundView.layer.borderColor = theme.colorTheme.tertiary.cgColor
        mainBackgroundView.layer.borderWidth = 1.0
        
        middleElementsStackView.autoSetDimension(.height, toSize: authorViewHeight)
        addSubview(mainStackView)
        mainStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: gutter, bottom: 0, right: gutter),
                                                   excludingEdge: .bottom)
        mainStackView.autoPinEdge(.bottom, to: .bottom, of: mainBackgroundView, withOffset: -36, relation: .lessThanOrEqual)
        
        topImageView.layer.borderWidth = 1.0
        topImageView.layer.borderColor = theme.colorTheme.tertiary.cgColor
        
        didSetupConstraints = true
    }
    
}
