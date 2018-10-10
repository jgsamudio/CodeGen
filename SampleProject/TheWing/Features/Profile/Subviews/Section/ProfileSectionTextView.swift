//
//  ProfileSectionTextView.swift
//  TheWing
//
//  Created by Luna An on 3/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Profile section text view that includes both profile section header and text view.
final class ProfileSectionTextView: BuildableView {
    
    // MARK: - Private Properties
    
    private lazy var headerView = SectionHeaderView(theme: theme)
    
    private lazy var textView: UITextView = {
    
    // MARK: - Public Properties
    
        let textView =  UITextView()
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.contentInset = UIEdgeInsets(top: 0, left: -5, bottom: 10, right: 0)
        textView.sizeToFit()
        return textView
    }()

    // MARK: - Constants

    private static let bottomOffset: CGFloat = 13
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets profile text view with section title and text.
    ///
    /// - Parameters:
    ///   - title: Section title.
    ///   - text: Text under specific section.
    ///   - activated: View is activated
    func setProfileTextView(title: String, text: String?, activated: Bool = true) {
        headerView.set(title: title, activated: activated)
        let textColor = activated ? colorTheme.emphasisQuaternary : colorTheme.tertiary
        textView.setText(text ?? "", using: theme.textStyleTheme.bodyNormal.withColor(textColor))
        autoPinField()
    }
    
}

// MARK: - Private Functions
private extension ProfileSectionTextView {
    
    func setupDesign() {
        backgroundColor = theme.colorTheme.invertTertiary
        setupSectionHeader()
        setupTextView()
    }
    
    func setupSectionHeader() {
        addSubview(headerView)
        let insets = UIEdgeInsets(top: 0, left: ViewConstants.defaultGutter, bottom: 0, right: ViewConstants.defaultGutter)
        headerView.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
    }
    
    func setupTextView() {
        addSubview(textView)
        let insets = UIEdgeInsets(top: 32,
                                  left: ViewConstants.defaultGutter,
                                  bottom: ProfileSectionTextView.bottomOffset,
                                  right: ViewConstants.defaultGutter)
        textView.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
    }
    
    func autoPinField() {
        autoPinEdge(.bottom, to: .bottom, of: textView, withOffset: ProfileSectionTextView.bottomOffset)
    }
    
}
