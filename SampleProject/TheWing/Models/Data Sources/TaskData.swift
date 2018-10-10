//
//  TaskData.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct TaskData {
    
    // MARK: - Public Properties
    
    /// Title of task.
    let title: String
    
    /// Description of task.
    let description: String
    
    /// Title of the call to action.
    let buttonTitle: String
    
    /// Optional image url to download and display.
    let imageURL: URL?
    
    /// Feature association of task, e.g. event or profile.
    let type: TaskType
    
    /// Action type, e.g. redirect or acknowedge.
    let actionType: TaskActionType
    
    /// Exact action to take, to be evaluated with action type.
    let action: String
    
    /// Task identifier.
    let identifier: String
    
    // MARK: - Initialization
    
    /// Instantiates a container for display data associated with tasks given a raw task object.
    ///
    /// - Parameter rawTask: Raw task object.
    init(rawTask: Task) {
        title = rawTask.title
        description = rawTask.description
        buttonTitle = rawTask.buttonLabel
        imageURL = URL(string: rawTask.imageUrl)
        type = TaskType(rawValue: rawTask.type) ?? TaskType.unknown
        actionType = TaskActionType(rawValue: rawTask.buttonActionType) ?? TaskActionType.other
        action = rawTask.buttonAction
        identifier = rawTask.taskId
    }
    
}
