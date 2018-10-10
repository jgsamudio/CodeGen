//
//  ProfileFooterView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class ProfileFooterView: BuildableView {

    // MARK: - Private Properties
    
    private weak var delegate: ProfileFooterItemDelegate?
    
    private lazy var stackView: UIStackView = {
    
    // MARK: - Public Properties
    
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        addSubview(stackView)
        let bottomInset: CGFloat = UIScreen.isiPhoneXOrBigger ? 36 : 40
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 27, left: 32, bottom: bottomInset, right: 32))
        return stackView
    }()

    // MARK: - Initialization

    init(theme: Theme, delegate: ProfileFooterItemDelegate?) {
        self.delegate = delegate
        super.init(theme: theme)
        backgroundColor = theme.colorTheme.invertPrimaryMuted
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Sets up the view with the given parameter.
    ///
    /// - Parameter items: Items to load in the view.
    func setupView(items: [FooterItemType], showEmptyViews: Bool) {
        stackView.removeAllArrangedSubviews()
        for item in items {
            guard !item.isEmpty || (item.isEmpty && showEmptyViews && item.formattedText != nil) else {
                continue
            }
            let itemView = ProfileFooterItem(theme: theme, item: item, delegate: delegate)
            itemView.autoSetDimension(.height, toSize: 45, relation: .greaterThanOrEqual)
            stackView.addArrangedSubview(itemView)
        }
    }

}
