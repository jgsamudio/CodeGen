//
//  MainTabBarController.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class MainTabBarController: BuildableTabBarController {

    // MARK: - Public Properties

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return selectedTabBarItemViewController
    }

    var viewModel: MainTabBarViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }

    /// Delegate for account status.
    weak var accountDelegate: UserAccountDelegate?
    
    /// Tab bar item view controller for currently selected tab.
    var selectedTabBarItemViewController: TabBarItemViewController? {
        guard selectedIndex < tabBarItemViewControllers.count else {
            assertionFailure("Unexpected tab configuration")
            return nil
        }
        
        return tabBarItemViewControllers[selectedIndex]
    }
    
    var selectedDestination: TabDestination {
        return TabDestination(rawValue: selectedIndex)!
    }

    // MARK: - Private Properties
    
    private(set) lazy var homeViewController: TabBarItemViewController = {
        return builder.homeViewController(tabBarDelegate: self)
    }()
    
    private(set) lazy var eventsViewController: TabBarItemViewController = {
        return builder.eventsViewController(tabBarDelegate: self)
    }()
    
    private var tabBarItemViewControllers: [TabBarItemViewController] {
        return [homeViewController, eventsViewController, communityViewController]
    }

    private lazy var drawerContainerView: DrawerContainerView = {
        let containerView = DrawerContainerView(drawerView: menuDrawerView, theme: theme)
        containerView.delegate = self
        return containerView
    }()
    
    private lazy var menuDrawerView = MenuDrawerView(theme: theme, delegate: self)
    
    private lazy var communityViewController: TabBarItemViewController = {
        return builder.communityViewController(tabBarDelegate: self)
    }()
    
	// MARK: - Public Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = theme.colorTheme.invertPrimary
        setupTabs()
    }

}

// MARK: - Private Functions
private extension MainTabBarController {

    func setupTabs() {
        let navigationControllers = tabBarItemViewControllers.map {
            TabBarItemNavigationController(rootViewController: $0, theme: theme)
        }
        viewControllers = navigationControllers
    }
    
    func closeDrawer() {
        drawerContainerView.hide()
        enableTabViewsAccessibility()
    }
    
    func enableTabViewsAccessibility() {
        tabBarItemViewControllers.forEach { $0.enableAccessibility() }
        AccessibilityHelper.notifySignificantScreenChange(focusOn: selectedTabBarItemViewController?.headerView)
    }
    
    func disableTabViewsAccessibility() {
        let profileImage = menuDrawerView.headerView?.profileImageView
        tabBarItemViewControllers.forEach { $0.disableAccessibility() }
        AccessibilityHelper.notifySignificantScreenChange(focusOn: profileImage)
    }

    func openLink(_ url: URL) {
        closeDrawer()
        open(url)
    }

}

// MARK: - MainTabBarViewDelegate
extension MainTabBarController: MainTabBarViewDelegate {

    func contactUsSelected(email: String) {
        closeDrawer()
        presentEmailActionSheet(address: email)
    }

    func settingsSelected() {
        closeDrawer()
        navigationController?.pushViewController(builder.settingsViewController(delegate: accountDelegate), animated: true)
    }
    
    func privacyPolicySelected(url: URL) {
        openLink(url)
    }

    func termsAndConditionsSelected(url: URL) {
        openLink(url)
    }

}

// MARK: - MainTabBarDelegate
extension MainTabBarController: MainTabBarDelegate {

    var statusBarHidden: Bool {
        return !drawerContainerView.isDrawerHidden
    }

    func showDrawer() {
        menuDrawerView.profileImageURLString = viewModel.profileImageUrlString
        drawerContainerView.show()
        disableTabViewsAccessibility()
    }

    func push(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }

    func getProfileImage(completion: @escaping ((UIImage?) -> Void)) {
        guard let urlString = viewModel.profileImageUrlString, let profileUrl = URL(string: urlString) else {
            return
        }
        AlamoFireImageLoader.loadImage(url: profileUrl, completion: completion)
    }
    
    func houseRulesSelected() {
        closeDrawer()
        navigationController?.pushViewController(builder.houseRulesViewController(), animated: true)
    }

}

// MARK: - DrawerContainerDelegate
extension MainTabBarController: DrawerContainerDelegate {

    func updateStatusBarStatus() {
        setNeedsStatusBarAppearanceUpdate()
    }

}

// MARK: - MenuDrawerHeaderDelegate
extension MainTabBarController: MenuDrawerHeaderDelegate {

    func profileSelected() {
        guard let userId = viewModel.userId else {
            return
        }
        closeDrawer()
        
        let properties = currentUser?.analyticsProperties(forScreen: self, andAdditionalProperties: [
            AnalyticsConstants.ProfileCTA.key: AnalyticsConstants.ProfileCTA.menuButton.analyticsIdentifier
        ])
        analyticsProvider.track(event: AnalyticsEvents.Profile.profileClicked.analyticsIdentifier,
                                properties: properties,
                                options: nil)
        
        navigationController?.pushViewController(builder.profileViewController(userId: userId), animated: true)
    }

    func closeButtonSelected() {
        closeDrawer()
    }

    func itemSelected(type: MenuItemType) {
        viewModel.menuItemSelected(type: type)
    }
    
}

// MARK: - AnalyticsIdentifiable
extension MainTabBarController: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return selectedDestination.analyticsIdentifier
    }
    
}
