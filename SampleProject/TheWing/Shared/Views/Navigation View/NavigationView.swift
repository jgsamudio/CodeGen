//
//  NavigationView.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class NavigationView: BuildableView {
    
    // MARK: - Public Properties
    
    weak var delegate: NavigationViewDelegate?
    
    // MARK: - Private Properties
    
    private var backButtonImage = #imageLiteral(resourceName: "back_button")

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(backButtonImage, for: .normal)
        button.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        button.addTarget(self, action: #selector(backActionTouchUpInside), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(numberOfLines: 0)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    // MARK: - Initialization

    init(theme: Theme, backButtonImage: UIImage = #imageLiteral(resourceName: "back_button")) {
        super.init(theme: theme)
        self.backButtonImage = backButtonImage
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets the title of the navigation view.
    ///
    /// - Parameter title: Title text.
    func set(title: String) {
        titleLabel.setText(title, using: theme.textStyleTheme.headline3)
    }
    
    /// Shows or hides the header items.
    ///
    /// - Parameter show: Flag to show header items or not.
    func showHeaderItems(show: Bool) {
        let alpha: CGFloat = show ? 0 : 1
        UIView.animate(withDuration: AnimationConstants.defaultDuration) {
            self.titleLabel.alpha = alpha
            self.backButton.alpha = alpha
        }
    }

}

// MARK: - Private Functions
private extension NavigationView {
    
    func setupDesign() {
        autoSetDimension(.height, toSize: 88)
        setupBackButton()
        setupTitleLabel()
    }
    
    func setupBackButton() {
        addSubview(backButton)
        backButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        backButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.autoAlignAxis(.vertical, toSameAxisOf: self)
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: backButton)
    }
    
    @objc func backActionTouchUpInside() {
        delegate?.backButtonSelected()
    }
    
}
