//
//  AnnoucementsViewDelegate.swift
//  TheWing
//
//  Created by Paul Jones on 7/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol HomeAnnouncementsViewDelegate: class {

    /// Notifies delegate that item at given index path was selected.
    ///
    /// - Parameter indexPath: Index path of item.
    func didSelectItemAt(_ indexPath: IndexPath)
    
}
