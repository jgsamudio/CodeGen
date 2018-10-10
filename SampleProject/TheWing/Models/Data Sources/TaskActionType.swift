//
//  TaskActionType.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Type of action associated with a task.
///
/// - redirect: Redirect -- take the user to another location.
/// - acknowledge: Acknowledge -- user must acknowledge that they have seen the task.
/// - other: Miscellaneous.
enum TaskActionType: String {
    case redirect
    case acknowledge
    case other
}
