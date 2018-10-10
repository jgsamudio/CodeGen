//
//  RootViewController.swift
//  TheWing
//
//  Created by Jonathan Samudio on 2/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Marker
import PureLayout

/// Root view controller class.
final class RootViewController: BuildableViewController {

    // MARK: - Public Properties

    /// Current view controller being presented.
    var currentViewController: UIViewController?
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return currentViewController
    }
    
    /// View model.
    var viewModel: RootViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    /// Tab destination.
    var destination: TabDestination = .home {
        didSet {
            mainViewController?.selectedIndex = destination.rawValue
        }
    }
    
    // MARK: - Private Properties
    
    private(set) var mainViewController: MainTabBarController?

    // MARK: - Private Properties
    
    private var onboardingNavigationController: UIViewController?

    private var loginViewController: UIViewController?

    private lazy var reachabilityNotifier = ReachabilityNotifier(delegate: self)
    
	// MARK: - Public Functions

    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.checkLoginStatus()
        reachabilityNotifier.subscribeToReachabilityChanges()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reachabilityNotifier.checkReachabilityStatus()
    }

}

// MARK: - Private Functions
private extension RootViewController {
    
    func setupNotificationsTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 900) {
            self.presentPushPermissionAlertIfNeeded()
        }
    }
    
    func setChild(viewController: UIViewController) {
        addChildViewController(viewController)
        addSubView(viewController: viewController)
        currentViewController = viewController
        viewController.view.frame = view.frame
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func addSubView(viewController: UIViewController) {
        if let currentView = currentViewController?.view {
            view.insertSubview(viewController.view, belowSubview: currentView)
        } else {
            view.addSubview(viewController.view)
        }
    }
    
    func transition(from currentViewController: UIViewController, to viewController: UIViewController) {
        setChild(viewController: viewController)
        viewController.didMove(toParentViewController: self)
        animate(from: currentViewController, to: viewController)
    }
    
    func animate(from currentViewController: UIViewController, to viewController: UIViewController) {
        UIView.animate(withDuration: AnimationConstants.defaultDuration, animations: {
            currentViewController.view.frame.origin.y = currentViewController.view.frame.height
        }) { _ in
            currentViewController.view.removeFromSuperview()
            currentViewController.removeFromParentViewController()
        }
    }

}

// MARK: - RootViewDelegate
extension RootViewController: RootViewDelegate {

    func transitionToLogin() {
        switch (currentViewController, loginViewController) {
        case (nil, nil):
            loginViewController = builder.loginViewController(delegate: self)
            setChild(viewController: loginViewController!)
        case (let .some(currentViewController), nil):
            loginViewController = builder.loginViewController(delegate: self)
            transition(from: currentViewController, to: loginViewController!)
        case (let .some(currentViewController), let .some(loginViewController)):
            transition(from: currentViewController, to: loginViewController)
        case (nil, let .some(loginViewController)):
            setChild(viewController: loginViewController)
        }
    }
    
    func transitionToOnboarding() {
        switch (currentViewController, onboardingNavigationController) {
        case (nil, nil):
            onboardingNavigationController = builder.onboardingContainerViewController()
            setChild(viewController: onboardingNavigationController!)
        case (let .some(currentViewController), nil):
            onboardingNavigationController = builder.onboardingContainerViewController()
            transition(from: currentViewController, to: onboardingNavigationController!)
        case (let .some(currentViewController), let .some(onboardingNavigationController)):
            transition(from: currentViewController, to: onboardingNavigationController)
        case (nil, let .some(onboardingNavigationController)):
            setChild(viewController: onboardingNavigationController)
        }
    }

    func transitionToMainApp() {
        switch (currentViewController, mainViewController) {
        case (nil, nil):
            mainViewController = builder.mainViewController(delegate: self,
                                                            destination: destination) as? MainTabBarController
            setChild(viewController: mainViewController!)
        case (let .some(currentViewController), nil):
            mainViewController = builder.mainViewController(delegate: self,
                                                            destination: destination) as? MainTabBarController
            transition(from: currentViewController, to: mainViewController!)
        case (let .some(currentViewController), let .some(mainViewController)):
            transition(from: currentViewController, to: mainViewController)
        case (nil, let .some(mainViewController)):
            setChild(viewController: mainViewController)
        }
        
        NotificationCenter.default.post(name: Notification.Name.EnteredMainTabBar, object: nil)
        setupNotificationsTimer()
    }

}

// MARK: - LoginDelegate
extension RootViewController: LoginDelegate {

    func userLoggedIn() {
        viewModel.userLoggedIn()
    }

}

// MARK: - UserAccountDelegate
extension RootViewController: UserAccountDelegate {

    func userLoggedOut() {
        loginViewController = nil
        transitionToLogin()
        mainViewController = nil
        onboardingNavigationController = nil
        viewModel.logOutUser()
    }

}

// MARK: - ReachabilityNotifierDelegate
extension RootViewController: ReachabilityNotifierDelegate {

    func networkUnreachable() {
        showSnackBar(with: SnackBarLocalization.connectivityError)
    }

    func networkReachable() {
        hideSnackBar()
    }

}
