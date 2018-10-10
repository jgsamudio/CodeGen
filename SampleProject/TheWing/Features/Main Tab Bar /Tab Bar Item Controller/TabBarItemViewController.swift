//
//  TabBarItemViewController.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

class TabBarItemViewController: BuildableViewController, TabBarDataSource {

    // MARK: - Public Properties

    override var prefersStatusBarHidden: Bool {
        return tabBarDelegate?.statusBarHidden ?? false
    }

    /// Delegate of the main tab bar.
    weak var tabBarDelegate: MainTabBarDelegate?

    /// Top constraint of header view.
    var headerViewTopConstraint: NSLayoutConstraint?

    /// Header view.
    lazy var headerView: AccessibilityHeaderView = {
        return tabItemHeaderView
    }()

    // MARK: - Private Properties

    private lazy var tabItemHeaderView: TabItemHeaderView = {
        let headerView = TabItemHeaderView(title: tabBarHeaderTitle(), subtitle: tabBarHeaderSubtitle(), theme: theme)
        headerView.delegate = self
        return headerView
    }()
    
    // MARK: - Public Functions
    
    func tabBarItemTitle() -> String {
        return ""
    }
    
    func tabBarHeaderTitle() -> String {
        return tabBarItemTitle()
    }
    
    func tabBarHeaderSubtitle() -> String? {
        return nil
    }

    func tabBarIcon() -> (selected: UIImage?, unselected: UIImage?) {
        return (nil, nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadProfileImage()
    }
    
    /// Enables accessibility usage for child elements.
    func enableAccessibility() {
        headerView.enableAccessibility()
    }
    
    /// Disables accessibility usage for child elements.
    func disableAccessibility() {
        headerView.disableAccessibility()
    }
    
    /// Resets search text field.
    ///
    /// - Parameter hasSearchText: Flag to indicate if search text was previous entered.
    func resetSearchField(hasSearchText: Bool) {
        headerView.resetSearchField(hasSearchText: hasSearchText)
    }
    
    /// Sets title and subtitle of header view.
    ///
    /// - Parameters:
    ///   - title: Title of header view.
    ///   - subtitle: Optional subtitle of header view.
    func setHeader(title: String, subtitle: String) {
        tabItemHeaderView.set(title: title, subtitle: subtitle)
    }

}

// MARK: - Private Functions
private extension TabBarItemViewController {
    
    func setupHeaderView() {
        view.addSubview(headerView)
        headerViewTopConstraint = headerView.autoPinEdge(.top, to: .top, of: view)
        headerView.autoPinEdge(.leading, to: .leading, of: view)
        headerView.autoPinEdge(.trailing, to: .trailing, of: view)
    }

    func reloadProfileImage() {
        tabBarDelegate?.getProfileImage(completion: { (image) in
            if let image = image {
                self.headerView.set(profileImage: image)
            }
        })
    }

}

// MARK: - TabItemHeaderViewDelegate
extension TabBarItemViewController: TabItemHeaderViewDelegate {

    func profileImageSelected() {
        tabBarDelegate?.showDrawer()
    }

}
