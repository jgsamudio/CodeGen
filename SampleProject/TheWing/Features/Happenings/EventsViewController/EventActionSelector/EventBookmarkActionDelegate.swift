//
//  EventBookmarkActionDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/5/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EventBookmarkActionDelegate: class {

    /// Called when the user selectes the bookmark button.
    ///
    /// - Parameter isBookmarked: Button bookmark status.
    func bookmarkEventSelected(isBookmarked: Bool)

}
