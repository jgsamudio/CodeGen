//
//  TaskCellViewOptions.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

struct TaskCellViewOptions {
    
    // MARK: - Public Properties
    
    /// Title of task.
    let title: String
    
    /// Description of task.
    let description: String
    
    /// Button title associated with task action.
    let buttonTitle: String
    
    /// Button style associated with task action.
    let buttonStyle: ButtonStyle
    
    /// Boolean determining if cell should show fancy frame.
    let isFancy: Bool
    
    /// URL of image associated with task.
    let imageURL: URL?
    
}
