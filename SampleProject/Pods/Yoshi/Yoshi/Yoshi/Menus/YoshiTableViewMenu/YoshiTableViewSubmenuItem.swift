//
//  YoshiTableViewSubmenuItem.swift
//  Yoshi
//
//  Created by Kanglei Fang on 29/06/2017.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

/// Internal struct that map the YoshiTableViewMenuItem to a YoshiGenericMenu.
/// This menu is interannly used to support YoshiTableViewMenu.
internal struct YoshiTableViewSubmenuItem: YoshiGenericMenu {

    // MARK: - Public Properties
    
    let name: String
    let subtitle: String?
    var selected: Bool

    // MARK: - Private Properties
    
    private var tableViewMenuItem: YoshiTableViewMenuItem
    private var action: (_ displayItem: YoshiTableViewMenuItem) -> Void

    // MARK: - Initialization
    
    init(tableViewMenuItem: YoshiTableViewMenuItem, action: @escaping (_ displayItem: YoshiTableViewMenuItem) -> Void) {
        self.name = tableViewMenuItem.name
        self.subtitle = tableViewMenuItem.subtitle
        self.selected = tableViewMenuItem.selected
        self.tableViewMenuItem = tableViewMenuItem
        self.action = action
    }

    var cellSource: YoshiReusableCellDataSource {
        return YoshiMenuCellDataSource(title: name, subtitle: subtitle, accessoryType: selected ? .checkmark : .none)
    }

    // MARK: - Public Functions
    
    func execute() -> YoshiActionResult {
        action(tableViewMenuItem)
        return .pop
    }

}
