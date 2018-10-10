//
//  YoshiSingleSelectionMenuItem.swift
//  Yoshi
//
//  Created by Kanglei Fang on 7/2/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

/// Internal YoshiGenericMenu used for single selection menu.
internal final class YoshiSingleSelectionMenuItem: YoshiGenericMenu {

    // MARK: - Public Properties
    
    var title: String {
        return selection.title
    }

    var subtitle: String? {
        return selection.subtitle
    }

    // MARK: - Private Properties
    
    private var selected: Bool
    private let selection: YoshiSingleSelection
    private var action: ((YoshiSingleSelection) -> Void)?

    // MARK: - Initialization
    
    init(selection: YoshiSingleSelection,
         selected: Bool,
         action: ((YoshiSingleSelection) -> Void)?) {
        self.selection = selection
        self.selected = selected
        self.action = action
    }

    var cellSource: YoshiReusableCellDataSource {
        return YoshiMenuCellDataSource(title: title, subtitle: subtitle, accessoryType: selected ? .checkmark : .none)
    }

    // MARK: - Public Functions
    
    func execute() -> YoshiActionResult {
        action?(selection)
        return .pop
    }
}
