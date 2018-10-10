//
//  TagViewDataSource.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

protocol TagViewDataSource {

    /// Determines if the cell is removeable.
    var isRemovable: Bool { get }

    /// Determines if the cell is selectable.
    var isSelectable: Bool { get }

    /// Determines if the cell was selected.
    var selected: Bool { get }
    
    /// Cell background of the tag view.
    ///
    /// - Parameter theme: Theme of the application.
    /// - Returns: Background color.
    func cellBackgroundColor(theme: Theme) -> UIColor

}
