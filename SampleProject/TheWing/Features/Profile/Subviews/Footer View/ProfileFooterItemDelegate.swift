//
//  ProfileFooterItemDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol ProfileFooterItemDelegate: EmptyStateViewDelegate {

    /// Called when the footer item is selected.
    ///
    /// - Parameter item: Item that was selected.
    func viewSelected(item: FooterItemType)
    
}

