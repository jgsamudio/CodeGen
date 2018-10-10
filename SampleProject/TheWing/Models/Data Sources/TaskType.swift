//
//  TaskType.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Enum describing the feature associated with a task.
///
/// - profileIncomplete: Profile-related task.
/// - bookmarksOpen: Event-related task.
/// - announcement: General task.
/// - unknown: Task of unknown feature association.
enum TaskType: String {
    case profileIncomplete
    case bookmarksOpen
    case announcment
    case unknown
    
    // MARK: - Public Functions
    
    /// Returns the style for the call to action associated with given task.
    ///
    /// - Parameter buttonStyleTheme: Button style theme.
    /// - Returns: Button style to use with Stylized Button objects.
    func buttonStyle(buttonStyleTheme: ButtonStyleTheme) -> ButtonStyle {
            return buttonStyleTheme.secondaryDarkButtonStyle
    }

}
