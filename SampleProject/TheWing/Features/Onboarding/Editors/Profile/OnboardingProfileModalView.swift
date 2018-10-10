//
//  OnboardingProfileModalView.swift
//  TheWing
//
//  Created by Paul Jones on 7/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// The modal that shows up at the beginning of using the profile VC in onboarding.
final class OnboardingProfileModalView: BuildableView {

    // MARK: - Public Properties

    /// This is the view delegate that will tell you when to dismiss.
    weak var delegate: OnboardingProfileModalViewDelegate?
    
    /// Set this property toget the user's image in the fancy frame in the center.
    var userImageUrl: URL? {
        didSet {
            if let url = userImageUrl {
                userImageFancyFrameView.setImage(url: url)
            }
        }
    }
    
    /// Set this property to have the user's name appear in the welcome message.
    var userFirstName: String? {
        didSet {
            let messageLabelText = OnboardingLocalization.buildProfileModalMessageLabelText(withUserName: userFirstName)
            messageLabel.setText(messageLabelText, using: textStyleTheme.bodyNormal)
        }
    }
    
    // MARK: - Private Properties

    private lazy var containerView = UIView()
    
    private lazy var largeSparkleImageView = UIImageView(image: #imageLiteral(resourceName: "sparkles_icon"))
    
    private lazy var smallSparkleImageView = UIImageView(image: #imageLiteral(resourceName: "sparkles_small"))
    
    private lazy var titleLabel = UILabel(numberOfLines: 1)
    
    private lazy var userImageFancyFrameView = FancyFrameView(theme: theme)
    
    private lazy var messageLabel = UILabel(numberOfLines: 0)
    
    private lazy var dismissButton = StylizedButton(buttonStyle: theme.buttonStyleTheme.secondaryFiveButtonStyle)
    
    private lazy var arrangedSubviews = [titleLabel, userImageFancyFrameView, messageLabel, dismissButton]
    
    private lazy var mainStackView = UIStackView(arrangedSubviews: arrangedSubviews,
                                                 axis: .vertical,
                                                 distribution: .fill,
                                                 alignment: .fill,
                                                 spacing: 25)
    
    private var height: CGFloat = 475

    // MARK: - Initialization

    override init(theme: Theme) {
        super.init(theme: theme)
        
        autoSetDimensions(to: CGSize(width: ViewConstants.defaultWidth, height: height))
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.backgroundColor = theme.colorTheme.invertTertiary
        containerView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 60, left: 0, bottom: 30, right: 0))
        
        containerView.addSubview(mainStackView)
        mainStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 30, left: 40, bottom: 40, right: 40))
        
        titleLabel.setText(OnboardingLocalization.profileModalTitleLabelText, using: theme.textStyleTheme.headline1)
        titleLabel.textAlignment = .center
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        messageLabel.autoSetDimension(.height, toSize: 84)

        let userImageFancyFrameViewHeight: CGFloat = 90
        userImageFancyFrameView.image = #imageLiteral(resourceName: "avatar")
        userImageFancyFrameView.autoSetDimension(.height, toSize: userImageFancyFrameViewHeight)
        userImageFancyFrameView.cornerRadius = userImageFancyFrameViewHeight / 2
        
        dismissButton.autoSetDimension(.height, toSize: 44)
        let buttonTitle = OnboardingLocalization.profileModalDismissButtonText
        dismissButton.accessibilityLabel = buttonTitle
        dismissButton.setTitle(buttonTitle.uppercased())
        dismissButton.addTarget(self, action: #selector(didTouchUpInsideDismissButton), for: .touchUpInside)
        
        addSubview(largeSparkleImageView)
        largeSparkleImageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 40)
        largeSparkleImageView.autoPinEdge(.top, to: .top, of: self, withOffset: 0)
        largeSparkleImageView.autoSetDimensions(to: CGSize(width: 116, height: 72))
        
        addSubview(smallSparkleImageView)
        smallSparkleImageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 40)
        smallSparkleImageView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0)
        smallSparkleImageView.autoSetDimensions(to: CGSize(width: 53, height: 43))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Functions
private extension OnboardingProfileModalView {
    
    @objc func didTouchUpInsideDismissButton() {
        delegate?.onboardingProfileModalViewDidTouchUpInsideDismissButton(view: self)
    }
    
}
