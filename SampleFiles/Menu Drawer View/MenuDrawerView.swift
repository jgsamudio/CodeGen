//
//  MenuDrawerView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Pilas

/// <Description of the class>
///
/// **Subspec: Folder/Filename**
///
/// ```
/// Code Snippet
/// ```
///
/// <Real world example of how someone would use this class with code snippet>
final class MenuDrawerView: UIView {

    // MARK: - Public Properties
    
    /// Delegate.
    weak var delegate: MenuDrawerHeaderDelegate?
    
    // MARK: - Public Properties
    
    var profileImageURLString: String? {
        didSet {
            headerView?.profileImageURLString = profileImageURLString
        }
    }
    
    /// Header view.
    private(set) var headerView: MenuDrawerHeaderView?

    // MARK: - Private Properties

    private let scrollView = PilasScrollView()

    // MARK: - Constants

    fileprivate static let closeButtonSize = 44
    
    // MARK: - Initialization
    
    init(theme: Theme, delegate: MenuDrawerHeaderDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        configureView(theme: theme)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Functions
private extension MenuDrawerView {

    func configureView(theme: Theme) {
        backgroundColor = theme.colorTheme.primary
        autoSetDimension(.width, toSize: UIScreen.width * 0.84)

        setupCloseButton(theme: theme)
        setupStackView(theme: theme)
    }

    func setupCloseButton(theme: Theme) {
        let closeButton = UIButton()
        closeButton.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        closeButton.tintColor = theme.colorTheme.invertPrimary
        closeButton.addTarget(self, action: #selector(didSelectCloseButton), for: .touchUpInside)

        addSubview(closeButton)
        closeButton.autoSetDimensions(to: CGSize(width: MenuDrawerView.closeButtonSize,
                                                 height: MenuDrawerView.closeButtonSize))
        closeButton.autoPinEdge(.top, to: .top, of: self, withOffset: 51)
        closeButton.autoPinEdge(.leading, to: .leading, of: self, withOffset: 33)
    }

    func setupStackView(theme: Theme) {
        addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 136, left: 0, bottom: 0, right: 0))

        scrollView.insertView(view: headerView(theme: theme))
        MenuItemType.menuListItems.forEach {
            scrollView.insertView(view: MenuDrawerItem(theme: theme, type: $0, delegate: delegate))
        }
    }

    func headerView(theme: Theme) -> MenuDrawerHeaderView {
        let headerView = MenuDrawerHeaderView(theme: theme)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectProfile))
        headerView.addGestureRecognizer(gestureRecognizer)
        self.headerView = headerView
        return headerView
    }

    @objc func didSelectProfile() {
        delegate?.profileSelected()
    }

    @objc func didSelectCloseButton() {
        delegate?.closeButtonSelected()
    }
    
}

// MARK: - ProfileViewDelegate
extension MenuDrawerView: ProfileViewDelegate {

}
