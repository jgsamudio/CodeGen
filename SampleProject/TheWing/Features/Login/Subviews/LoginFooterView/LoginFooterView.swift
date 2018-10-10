//
//  LoginFooterView.swift
//  TheWing
//
//  Created by Luna An on 3/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Login footer view.
final class LoginFooterView: BuildableView {
    
    // MARK: - Public Properties
    
    /// Login footer view delegate.
    weak var delegate: LoginFooterViewDelegate?
    
    // MARK: - Private Properties
    
    private lazy var borderView: UIView = {
        let border = UIView.dividerView(height: 1, color: theme.colorTheme.tertiaryMuted)
        addSubview(border)
        return border
    }()
    
    private lazy var privacyButton = UIButton()
    
    private lazy var andLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.isAccessibilityElement = false
        return label
    }()
    
    private lazy var termsOfUseButton = UIButton()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [privacyButton, andLabel, termsOfUseButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 4
        addSubview(stackView)
        return stackView
    }()
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Functions
private extension LoginFooterView {
    
    func setupDesign() {
        backgroundColor = theme.colorTheme.secondary
        setupBorderView()
        setupStackView()
    }
    
    func setupBorderView() {
        borderView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
    }
    
    func setupStackView() {
        setupPrivacyPolicy()
        setupAndLabel()
        setupTermsOfUse()
        positionStackView()
    }
    
    func positionStackView() {
        let offset: CGFloat = UIScreen.isiPhoneXOrBigger ? -10 : 0
        stackView.autoAlignAxis(.horizontal, toSameAxisOf: self, withOffset: offset)
        stackView.autoAlignAxis(.vertical, toSameAxisOf: self)
    }
    
    func setupPrivacyPolicy() {
        let textStyle = theme.textStyleTheme.bodyNormal.withLineSpacing(0)
                        .withColor(theme.colorTheme.emphasisPrimary)
        privacyButton.addTarget(self, action: #selector(privacyPolicySelected), for: .touchUpInside)
        privacyButton.setTitleText("PRIVACY_POLICY_TITLE".localized(comment: "Privacy policy title"), using: textStyle)
    }
    
    func setupAndLabel() {
        let textStlye = theme.textStyleTheme.bodyNormal.withLineSpacing(0)
        andLabel.setText("AND_TITLE".localized(comment: "And title"), using: textStlye)
    }
    
    func setupTermsOfUse() {
        let textStyle = theme.textStyleTheme.bodyNormal.withLineSpacing(0)
                        .withColor(theme.colorTheme.emphasisPrimary)
        termsOfUseButton.addTarget(self, action: #selector(termsOfUseSelected), for: .touchUpInside)
        let termsAndConditions = "TERMS_AND_CONDITIONS_TITLE".localized(comment: "Terms and conditions title")
        termsOfUseButton.setTitleText(termsAndConditions, using: textStyle)
    }
    
    @objc func privacyPolicySelected() {
        delegate?.privacyPolicySelected()
    }
    
    @objc func termsOfUseSelected() {
        delegate?.termsAndConditionsSelected()
    }
    
}
