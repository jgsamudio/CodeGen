//
//  DeepLinkHandler.swift
//  TheWing
//
//  Created by Luna An on 5/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class DeepLinkHandler {
    
    // MARK: - Private Properties
    
    private let builder: Builder
    
    private let window: UIWindow
    
    private var navigationController: UINavigationController? {
        return window.rootViewController as? UINavigationController
    }
    
    private var rootViewController: RootViewController? {
        return navigationController?.viewControllers.first as? RootViewController
    }
    
    private var tabBarController: MainTabBarController? {
        return rootViewController?.currentViewController as? MainTabBarController
    }
    
    // MARK: - Initialization
    
    /// Instantiates a deeplink handler object given a window object and builder.
    ///
    /// - Parameters:
    ///   - window: UIWindow.
    ///   - builder: Builder.
    init(window: UIWindow, builder: Builder) {
        self.builder = builder
        self.window = window
    }
    
    // MARK: - Public Functions
    
    /// Handle deep link data.
    ///
    /// - Parameters:
    ///   - deepLinkData: Optional data in deep link.
    ///   - error: Optional error.
    func handle(deepLinkData: [AnyHashable: Any]?, error: Error?) {
        guard error == nil,
            let params = deepLinkData as? [String: AnyObject],
            let clickedBranchLink = params[DeepLinkKeys.clickedBranchLink.rawValue] as? Bool else {
                return
        }
        
        if clickedBranchLink {
            route(params: params)
        } else if let path = params[DeepLinkKeys.deeplinkPath.rawValue] as? String {
            routeViaPath(path: path)
        }
    }
    
}

// MARK: - Private Functions
private extension DeepLinkHandler {
    
    func route(params: [String: AnyObject]) {
        if let eventId = params[DeepLinkKeys.edp.rawValue] as? String {
            routeToEdp(eventId: eventId)
        } else if let announcementId = params[DeepLinkKeys.announcement.rawValue] as? String {
            routeToAnnouncement(announcementId: announcementId)
        } else if let destination = params[DeepLinkKeys.destination.rawValue] as? String {
            routeViaPath(path: destination)
        } else if let path = params[DeepLinkKeys.deeplinkPath.rawValue] as? String {
            routeViaPath(path: path)
        }
    }
    
    func routeViaPath(path: String) {
    
    // MARK: - Public Properties
    
        let pathComponents = path.lowercased().components(separatedBy: "/")
        guard !pathComponents.isEmpty, let deepLinkPath = DeepLinkPaths(rawValue: pathComponents[0]) else {
            return
        }
        
        switch deepLinkPath {
        case .home:
            routeToTab(destination: .home)
        case .happenings:
            if pathComponents.count > 1, !pathComponents[1].isEmpty {
                routeToEdp(eventId: pathComponents[1])
            } else {
                routeToTab(destination: .happenings)
            }
        case .community:
            routeToTab(destination: .community)
        case .myHappenings:
            routeToMyHappenings(type: .myHappenings)
        case .myBookmarks:
            routeToMyHappenings(type: .bookmarkedHappenings)
        case .profile:
            routeToProfile()
        case .announcements:
            if pathComponents.count > 1, !pathComponents[1].isEmpty {
                routeToAnnouncement(announcementId: pathComponents[1])
            } else {
                routeToTab(destination: .home)
            }
        }
    }
    
    private func routeToEdp(eventId: String) {
        guard let navigationController = navigationController,
            let eventsViewController = tabBarController?.eventsViewController as? EventsViewController,
            let eventStatusDelegate = eventsViewController.viewModel else {
                return
        }
        
        let edpPage = builder.eventDetailViewController(eventId: eventId, eventStatusDelegate: eventStatusDelegate)
        navigationController.pushViewController(edpPage, animated: true)
    }
    
    private func routeToAnnouncement(announcementId: String) {
        guard let navigationController = navigationController,
            let rootViewController = rootViewController,
            let tabBarController = tabBarController,
            let homeViewController = tabBarController.homeViewController as? HomeViewController,
            let homeViewModel = homeViewController.viewModel,
            let data = (homeViewModel.announcements.filter { $0.identifier == announcementId }).first else {
                return
        }
        
        navigationController.popToViewController(rootViewController, animated: true)
        navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
        let announcementPage = builder.announcementViewController(announcement: data)
        navigationController.present(announcementPage, animated: true, completion: nil)
    }
    
    private func routeToMyHappenings(type: MyHappeningsType) {
        guard let navigationController = navigationController, tabBarController != nil else {
            return
        }
        
        let myHappenings = builder.myHappeningsViewController(type: type)
        navigationController.pushViewController(myHappenings, animated: true)
    }
    
    private func routeToTab(destination: TabDestination) {
        guard let navigationController = navigationController,
            let rootViewController = rootViewController,
            tabBarController != nil else {
                return
        }
        
        rootViewController.destination = destination
        navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
        navigationController.popToViewController(rootViewController, animated: true)
    }
    
    private func routeToProfile() {
        guard let navigationController = navigationController,
            let rootViewController = rootViewController,
            let tabBarController = tabBarController,
            let userId = tabBarController.viewModel.userId else {
                return
        }
        
        let myProfile = builder.profileViewController(userId: userId)
        navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
        navigationController.popToViewController(rootViewController, animated: true)
        navigationController.pushViewController(myProfile, animated: true)
    }
    
}
