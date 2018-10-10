//
//  ContactUsView.swift
//  TheWing
//
//  Created by Luna An on 7/5/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Contact Us view on Login.
final class ContactUsView: BuildableView {
    
    // MARK: - Public Properties
    
    /// Contact us view delegate.
    weak var delegate: ContactUsViewDelegate?
    
    // MARK: - Private Properties

    private lazy var needHelpLabel: UILabel = {
        let label = UILabel()
        label.setText("NEED_HELP".localized(comment: "Need help?"), using: theme.textStyleTheme.bodySmall)
        return label
    }()
    
    private lazy var contactUsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(contactUsSelected), for: .touchUpInside)
        button.setTitleText("CONTACT_US".localized(comment: "Contact Us"),
                            using: theme.textStyleTheme.bodySmall.withColor(theme.colorTheme.emphasisPrimary))
        return button
    }()
    
    private lazy var contactUsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [needHelpLabel, contactUsButton])
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
        setupStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Functions
private extension ContactUsView {
    
    func setupStackView() {
        contactUsStackView.autoPinEdge(.top, to: .top, of: self)
        contactUsStackView.autoAlignAxis(.vertical, toSameAxisOf: self)
    }
    
    @objc func contactUsSelected() {
        delegate?.contactUsSelected()
    }
    
}
