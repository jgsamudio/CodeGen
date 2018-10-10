//
//  FilterTagType.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

// MARK: - TagViewDataSource
struct FilterTagType: TagViewDataSource {
    
    // MARK: - Public Properties
    
    var isSelectable: Bool {
        return !selected
    }
    
    var selected: Bool
    
    var isRemovable: Bool {
        return false
    }

    // MARK: - Public Functions
    
    func cellBackgroundColor(theme: Theme) -> UIColor {
        return isSelectable ? theme.colorTheme.invertTertiary : theme.colorTheme.primary
    }
    
}
