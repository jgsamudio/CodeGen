//
//  PushNotificationPromptView.swift
//  TheWing
//
//  Created by Paul Jones on 8/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Velar

final class PushNotificationPromptView: BuildableView {
    
    // MARK: - Public Properties
    
    /// Delegate
    weak var delegate: PushNotificationPromptViewDelegate?
    
    /// Presenter, Velar
    weak var presenter: VelarPresenter?
    
    // MARK: - Private Properties
    
    private var height: CGFloat = 444
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.applySketchShadow(color: colorTheme.emphasisQuintary,
                                     alpha: 0.2,
                                     shadowX: 0,
                                     shawdowY: 9,
                                     blur: 30,
                                     spread: 0)
        view.backgroundColor = colorTheme.invertTertiary
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.tintColor = colorTheme.emphasisQuintary
        button.addTarget(self, action: #selector(deny), for: .touchUpInside)
        button.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        return button
    }()
    
    private lazy var titleLabel = UILabel(text: PushNotificationPromptViewLocalization.titleText,
                                          using: textStyleTheme.headline3,
                                          with: colorTheme.emphasisQuintary,
                                          alignment: .center)
    
    private lazy var imageView = UIImageView(image: #imageLiteral(resourceName: "push_calendar_alert"), contentMode: .scaleAspectFit)
    
    private lazy var detailLabel = UILabel(text: PushNotificationPromptViewLocalization.detailText,
                                           using: textStyleTheme.bodyNormal,
                                           with: colorTheme.emphasisQuaternary,
                                           alignment: .center)
    
    private lazy var confirmButton: StylizedButton = {
        let button = StylizedButton(buttonStyle: buttonStyleTheme.secondaryFourButtonStyle)
        button.setTitle(PushNotificationPromptViewLocalization.confirmText.uppercased())
        button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        return button
    }()
    
    private lazy var denyButton: StylizedButton = {
        let button = StylizedButton(buttonStyle: buttonStyleTheme.floatingTextPrimaryButtonStyle)
        button.setTitle(PushNotificationPromptViewLocalization.denyText.uppercased())
        button.setTitleColor(colorTheme.primary, for: .normal)
        button.addTarget(self, action: #selector(deny), for: .touchUpInside)
        return button
    }()
    
    private lazy var mainStackViewArrangedSubviews = [
        titleLabel,
        imageView,
        detailLabel,
        confirmButton,
        denyButton
    ]
    
    private lazy var mainStackView = UIStackView(arrangedSubviews: mainStackViewArrangedSubviews,
                                                 axis: .vertical,
                                                 distribution: .fill,
                                                 alignment: .fill)
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        
        autoSetDimension(.width, toSize: ViewConstants.defaultWidth)
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.backgroundColor = theme.colorTheme.invertTertiary
        containerView.autoPinEdgesToSuperviewEdges()
        imageView.autoSetDimensions(to: CGSize(width: 143, height: 143))
        
        containerView.addSubview(mainStackView)
        mainStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 27,
                                                                      left: ViewConstants.defaultGutter,
                                                                      bottom: 20,
                                                                      right: ViewConstants.defaultGutter))
        mainStackView.setCustomSpacing(43, after: titleLabel)
        mainStackView.setCustomSpacing(48, after: imageView)
        mainStackView.setCustomSpacing(15, after: detailLabel)
        mainStackView.setCustomSpacing(8, after: confirmButton)
        
        confirmButton.autoSetDimension(.height, toSize: 44)
        denyButton.autoSetDimension(.height, toSize: 44)
        
        addSubview(closeButton)
        closeButton.autoPinEdge(toSuperviewEdge: .right, withInset: 17)
        closeButton.autoPinEdge(toSuperviewEdge: .top, withInset: 17)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Functions

// MARK: - Private Functions
private extension PushNotificationPromptView {
    
    @objc func confirm() {
        delegate?.pushNotificationPromptViewDidConfirm(self)
        presenter?.hide(animate: true)
    }
    
    @objc func deny() {
        presenter?.hide(animate: true)
    }
    
}
