//
//  EmptyStateViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 8/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EmptyStateViewDelegate: class {
    
    /// Called when the empty state is selected.
    ///
    /// - Parameter type: Selected type.
    func emptyStateSelected(type: EmptyStateViewType)
    
}
