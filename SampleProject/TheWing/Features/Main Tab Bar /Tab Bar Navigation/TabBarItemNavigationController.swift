//
//  TabBarItemNavigationController.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Navigation controller that can set the tab bar item.
final class TabBarItemNavigationController: UINavigationController {

	// MARK: - Initialization

    // MARK: - Initialization
    
    init(rootViewController: UIViewController, theme: Theme) {
        super.init(rootViewController: rootViewController)
        setupTabBarItem(rootViewController, theme: theme)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

// MARK: - Private Functions
private extension TabBarItemNavigationController {

    func setupTabBarItem(_ rootViewController: UIViewController, theme: Theme) {
        guard let rootViewController = rootViewController as? TabBarDataSource else {
            return
        }
        tabBarItem = UITabBarItem(title: rootViewController.tabBarItemTitle(),
                                  image: rootViewController.tabBarIcon().unselected,
                                  selectedImage: rootViewController.tabBarIcon().selected)

    // MARK: - Public Properties
    
        var textAttributes = theme.textStyleTheme.captionSmall.withColor(theme.colorTheme.tertiary).attributes
        textAttributes[NSAttributedStringKey.font] = theme.textStyleTheme.captionSmall.strongFont
        
        tabBarItem.setTitleTextAttributes(textAttributes, for: .normal)
        setNavigationBarHidden(true, animated: false)
        transparentNavigationBar()
    }

}
