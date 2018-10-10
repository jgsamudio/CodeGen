//
//  OnboardingStageIntroAsksOffersView.swift
//  TheWing
//
//  Created by Paul Jones on 7/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingStageIntroAsksOffersView: BuildableView {
    
    // MARK: - Public Properties

    /// The alpha of the subviews associated with "asks"
    var asksAlpha: CGFloat {
        get {
            return asksLine.alpha
        } set {
            asksLine.alpha = newValue
            asksDivider.alpha = newValue
        }
    }
    
    /// The alpha of the subviews associated with "offers"
    var offersAlpha: CGFloat {
        get {
            return offersLine.alpha
        } set {
            offersLine.alpha = newValue
            offersDivider.alpha = newValue
        }
    }
    
    /// The alpha of the subviews associated with "and"
    var andAlpha: CGFloat {
        get {
            return andLabel.alpha
        } set {
            andLabel.alpha = newValue
        }
    }
    
    // Spacing of main stack view.
    var stackViewSpacing: CGFloat {
        get {
            return mainStackView.spacing
        } set {
            mainStackView.spacing = newValue
        }
        
    }
    
    // MARK: - Private Properties
    
    private lazy var asksLine = OnboardingStageIntroAsksOffersLine(theme: theme)
    
    private lazy var asksDivider = UIView(dividerWithSize: CGSize(width: 69.5, height: 1),
                                          backgroundColor: colorTheme.emphasisSecondary)
    
    private lazy var offersLine = OnboardingStageIntroAsksOffersLine(theme: theme)
    
    private lazy var offersDivider = UIView(dividerWithSize: CGSize(width: 105.5, height: 1),
                                            backgroundColor: colorTheme.emphasisSecondary)

    private lazy var andLabelText = OnboardingLocalization.introAsksOffersAndLabelText.lowercased()
    
    private lazy var andLabel = UILabel(text: andLabelText,
                                        using: textStyleTheme.headline3,
                                        with: colorTheme.emphasisSecondary)

    private lazy var mainStackViewArrangedSubviews = [asksLine, asksDivider, andLabel, offersLine, offersDivider]
    
    private lazy var mainStackView = UIStackView(arrangedSubviews: mainStackViewArrangedSubviews,
                                                 axis: .vertical,
                                                 distribution: .fill,
                                                 alignment: .leading,
                                                 spacing: 16)
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        addSubview(mainStackView)
        mainStackView.autoPinEdgesToSuperviewEdges()
        asksLine.titleText = OnboardingLocalization.asksTitle.uppercased()
        asksLine.detailText = OnboardingLocalization.asksDescription
        offersLine.titleText = OnboardingLocalization.offersTitle.uppercased()
        offersLine.detailText = OnboardingLocalization.offersDescription
        
        accessibilityLabel = "\(OnboardingLocalization.asksTitle), \(OnboardingLocalization.asksDescription) "
        + "\(andLabelText) \(OnboardingLocalization.offersTitle), \(OnboardingLocalization.offersDescription)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
