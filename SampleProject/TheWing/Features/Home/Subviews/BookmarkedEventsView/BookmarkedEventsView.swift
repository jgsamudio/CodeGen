//
//  BookmarkedEventsView.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class BookmarkedEventsView: BuildableView {

    // MARK: - Private Properties
    
    private lazy var titleLabel = UILabel(numberOfLines: 2)
    
    private lazy var countLabel = UILabel()
    
    private lazy var leftImageView: UIImageView = {
    
    // MARK: - Public Properties
    
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "bookmarked_icon")
        imageView.autoSetDimensions(to: CGSize(width: 10, height: 18))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "right_arrow")
        imageView.autoSetDimensions(to: CGSize(width: 8, height: 12))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    
    /// Sets the count label to the given count value.
    ///
    /// - Parameter count: Count value.
    func setCountLabel(count: Int) {
        countLabel.setText("\(count)", using: theme.textStyleTheme.displayLarge.withColor(theme.colorTheme.emphasisTertiary))
    }
    
    /// Sets the isHidden property of the right arrow view.
    ///
    /// - Parameter hidden: True, if should be hidden, false otherwise.
    func setArrowHidden(_ hidden: Bool) {
        rightImageView.isHidden = hidden
    }
    
}

// MARK: - Private Functions
private extension BookmarkedEventsView {
    
    func setupView() {
        backgroundColor = theme.colorTheme.primary
        setupLeftImageView()
        setupTitleLabel()
        setupRightImageView()
        setupCountLabel()
    }
    
    func setupLeftImageView() {
        addSubview(leftImageView)
        leftImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        leftImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.setMarkdownText(HomeLocalization.bookmarkedHappeningsTitle,
                           using: theme.textStyleTheme.bodyLarge.withColor(theme.colorTheme.secondary))
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        titleLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
        titleLabel.autoPinEdge(.leading, to: .trailing, of: leftImageView, withOffset: 22)
    }
    
    func setupRightImageView() {
        addSubview(rightImageView)
        rightImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        rightImageView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 19)
    }
    
    func setupCountLabel() {
        addSubview(countLabel)
        countLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        countLabel.autoPinEdge(.trailing, to: .leading, of: rightImageView, withOffset: -23)
    }
    
}
