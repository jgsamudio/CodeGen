//
//  ReusableView.swift
//  TheWing
//
//  Created by Luna An on 3/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Defines a reusable collection or table view cell.
protocol ReusableView: class {
    
    /// Default reuse identifier is set with the class name.
    static var reuseIdentifier: String { get }
    
}

extension ReusableView {
    
    // MARK: - Public Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
