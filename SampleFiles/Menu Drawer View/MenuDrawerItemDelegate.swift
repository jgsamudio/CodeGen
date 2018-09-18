//
//  MenuDrawerItemDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol MenuDrawerItemDelegate: class {

    /// Called when the menu item is selected.
    ///
    /// - Parameter type: Type of the menu item that is selected.
    func itemSelected(type: MenuItemType)

}