//
//  TaskCollectionViewCell.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class TaskCollectionViewCell: UICollectionViewCell {

    // MARK: - Private Properties
    
    private var taskCellView: TaskCellView?
    
    // MARK: - Public Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskCellView?.cancelImageRequests()
    }
    
    /// Sets the cell up with view options and action handler.
    ///
    /// - Parameters:
    ///   - cellOptions: Cell options.
    ///   - action: Action block.
    ///   - theme: Theme to use to set up this cell.
    func setup(cellOptions: TaskCellViewOptions, action: @escaping (() -> Void), theme: Theme) {
        setupTaskView(with: theme)
        taskCellView?.setup(options: cellOptions)
        taskCellView?.setAction(action)
    }
    
}

// MARK: - Private Functions
private extension TaskCollectionViewCell {
    
    func setupTaskView(with theme: Theme) {
        guard taskCellView == nil else {
            return
        }
        
    // MARK: - Public Properties
    
        let taskView = TaskCellView(theme: theme)
        addSubview(taskView)
        taskView.autoPinEdgesToSuperviewEdges()
        taskCellView = taskView
    }
    
}
