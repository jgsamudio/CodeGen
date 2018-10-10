//
//  ApplicationAppearance.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Object to manage the appearance of application.
struct ApplicationAppearance {
    
    // MARK: - Public Functions
    
    /// Sets application appearance given a theme.
    ///
    /// - Parameter theme: Theme.
    static func setup(with theme: Theme) {
        setupNavigationBarAppearance(with: theme)
        setupTabBarControllerAppearance(theme: theme)
        setupTextFieldAppearance(with: theme)
    }

    // MARK: - Private Functions

    private static func setupNavigationBarAppearance(with theme: Theme) {
        UINavigationBar.appearance().tintColor = theme.colorTheme.emphasisPrimary
        UINavigationBar.appearance().backIndicatorImage = #imageLiteral(resourceName: "back_button")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back_button")
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200.0, vertical: 0.0),
                                                                          for: .default)
    }
    
    private static func setupTabBarControllerAppearance(theme: Theme) {
    
    // MARK: - Public Properties
    
        let normalColor = theme.colorTheme.tertiary
        let selectedColor = theme.colorTheme.primary
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: normalColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor],
                                                         for: .selected)
    }
    
    private static func setupTextFieldAppearance(with theme: Theme) {
        let font = theme.textStyleTheme.bodyNormal.emFont.withSize(16)
        let attributes: [String: Any] = [NSAttributedStringKey.font.rawValue: font]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
    }
    
}
