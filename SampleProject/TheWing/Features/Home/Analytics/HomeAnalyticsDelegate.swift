//
//  HomeAnalyticsDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol HomeAnalyticsDelegate: class {
    
    /// Notifies delegate that the task was viewed.
    ///
    /// - Parameter data: Task data.
    func trackTaskViewed(data: TaskData, at index: Int)
    
    /// Notifies delegate that the call to action on the task was clicked.
    /// - Parameters:
    ///   - data: Task data.
    ///   - index: Index of task in checklist.
    func trackTaskCTAClicked(data: TaskData, at index: Int)
    
}
