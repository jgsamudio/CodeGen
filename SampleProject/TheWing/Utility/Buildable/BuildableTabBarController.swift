//
//  BuildableTabBarController.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Base tab bar view controller for the main views of the application.
class BuildableTabBarController: UITabBarController, Buildable {

	// MARK: - Public Properties

    // MARK: - Public Properties
    
    /// Builds view controllers for the application.
    let builder: Builder

    /// Theme of the application.
    let theme: Theme

	// MARK: - Initialization

    // MARK: - Initialization
    
    init(builder: Builder, theme: Theme) {
        self.builder = builder
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
