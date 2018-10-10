//
//  MemberCellOfferingAskingView.swift
//  TheWing
//
//  Created by Luna An on 8/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class MemberCellOfferingAskingView: BuildableView {
    
    // MARK: - Private Properties
    
    private lazy var separatorView: UIView = {
    
    // MARK: - Public Properties
    
        let view = UIView()
        view.autoSetDimension(.height, toSize: 1)
        let separator = UIView.dividerView(width: 93, color: colorTheme.emphasisSecondary)
        view.addSubview(separator)
        separator.autoPinEdge(.leading, to: .leading, of: view, withOffset: 85)
        separator.autoPinEdge(.top, to: .top, of: view)
        separator.autoPinEdge(.bottom, to: .bottom, of: view)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(dividerWithDimension: .height, constant: 12),
                                                       separatorView,
                                                       askingView,
                                                       offeringView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.setCustomSpacing(12, after: separatorView)
        return stackView
    }()
    
    private lazy var askingView = OfferingAskingListView(theme: theme)
    
    private lazy var offeringView = OfferingAskingListView(theme: theme)
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets view with offers and asks.
    ///
    /// - Parameters:
    ///   - offers: Offers to display.
    ///   - asks: Asks to display.
    func setup(offers: [String], asks: [String]) {
        if offers.count > 0 {
            offeringView.isHidden = false
            offeringView.setup(title: MembersLocalization.memberCellOfferingTitle, skills: offers)
        } else {
            offeringView.isHidden = true
        }
        
        if asks.count > 0 {
            askingView.isHidden = false
            askingView.setup(title: MembersLocalization.memberCellAskingTitle, skills: asks)
        } else {
            askingView.isHidden = true
        }
        
        if offers.count == 0, asks.count == 0 {
            separatorView.alpha = 0
            offeringView.isHidden = true
            askingView.isHidden = true
        } else {
            separatorView.alpha = 1
        }
    }

}

// MARK: - Private Functions
private extension MemberCellOfferingAskingView {
    
    func setupStackView() {
        addSubview(stackView)
        let insets = UIEdgeInsets(top: 0, left: 9, bottom: 12, right: 12)
        stackView.autoPinEdgesToSuperviewEdges(with: insets)
    }

}
