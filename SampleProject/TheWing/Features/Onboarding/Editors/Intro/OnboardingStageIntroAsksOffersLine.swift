//
//  OnboardingStageIntroAsksOffersLine.swift
//  TheWing
//
//  Created by Paul Jones on 7/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingStageIntroAsksOffersLine: BuildableView {
    
    // MARK: - Public Properties

    /// Set the title of this line
    var titleText: String? {
        set {
            titleLabel.setText(newValue ?? "", using: titleLabelTextStyle.withColor(titleLabelColor))
        }
        get {
            return titleLabel.text
        }
    }
    
    /// Set the detail of this line
    var detailText: String? {
        set {
            detailLabel.setText(newValue ?? "", using: detailLabelTextStyle.withColor(detailLabelColor))
        }
        get {
            return detailLabel.text
        }
    }
    
    // MARK: - Private Properties

    private lazy var titleLabelTextStyle = textStyleTheme.displayHuge
    
    private lazy var titleLabelColor = colorTheme.primary
    
    private lazy var detailLabelTextStyle = textStyleTheme.headline5
    
    private lazy var detailLabelColor = colorTheme.emphasisQuaternary
    
    private lazy var titleLabel = UILabel(using: titleLabelTextStyle, with: titleLabelColor, numberOfLines: 1)
    
    private lazy var detailLabel = UILabel(using: detailLabelTextStyle, with: detailLabelColor, numberOfLines: 0)
    
    // MARK: - Initialization

    override init(theme: Theme) {
        super.init(theme: theme)
        
        addSubview(titleLabel)
        addSubview(detailLabel)

        titleLabel.autoPinEdge(toSuperviewEdge: .top)
        titleLabel.autoPinEdge(toSuperviewEdge: .left)
        detailLabel.autoPinEdge(.top, to: .top, of: titleLabel, withOffset: -4)
        detailLabel.autoPinEdge(toSuperviewEdge: .right)
        detailLabel.autoPinEdge(toSuperviewEdge: .bottom)
        detailLabel.autoPinEdge(.left, to: .right, of: titleLabel, withOffset: 18)
        
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        detailLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        detailLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        isAccessibilityElement = false
    }
    
    // MARK: - Public Functions
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
