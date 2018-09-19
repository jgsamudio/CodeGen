//
//  MenuDrawerHeaderDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// <Description of the class>
///
/// **Subspec: Folder/Filename**
///
/// ```
/// Code Snippet
/// ```
///
/// <Real world example of how someone would use this class with code snippet>
/// ===== Generator Name: declarationHeader =====
protocol MenuDrawerHeaderDelegate: MenuDrawerItemDelegate {

    /// Called when the profile is selected.
    func profileSelected()

    /// Called when the close button is selected.
    func closeButtonSelected()
    
}
