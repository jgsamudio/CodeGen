//
//  Buildable.swift
//  TheWing
//
//  Created by Paul Jones on 8/29/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol Buildable {
    
    /// Builds view controllers for the application.
    var builder: Builder { get }
    
    /// Theme of the application.
    var theme: Theme { get }
    
}

extension Buildable {
    
    // MARK: - Public Properties
    
    /// Convenience to get right at the text style
    var textStyleTheme: TextStyleTheme {
        return theme.textStyleTheme
    }
    
    /// Convenience to get right at the color theme
    var colorTheme: ColorTheme {
        return theme.colorTheme
    }
    
    /// Convenience to get right at the button style theme
    var buttonStyleTheme: ButtonStyleTheme {
        return theme.buttonStyleTheme
    }
    
    /// Convenience to get right at the analytics provider. Yes, I am that lazy.
    var analyticsProvider: AnalyticsProvider {
        return builder.dependencyProvider.analyticsProvider
    }
    
    /// Also, a convinience to get right to the session manager.
    var sessionManager: SessionManager {
        return builder.dependencyProvider.networkProvider.sessionManager
    }
    
    /// Also, a convinience to get right to the user.
    var currentUser: User? {
        return sessionManager.user
    }

}
