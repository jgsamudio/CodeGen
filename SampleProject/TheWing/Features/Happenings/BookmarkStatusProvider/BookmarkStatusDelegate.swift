//
//  BookmarkStatusDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol BookmarkStatusDelegate: class {

    /// Called when the event bookmark status is updated.
    ///
    /// - Parameters
    ///   - eventId: Id of the event to update.
    ///   - status: Bookmark status. True, if bookmarked, false otherwise.
    func updateBookmark(eventId: String, status: Bool)

    /// Notifies delegate that an error occurred.
    ///
    /// - Parameter error: Error.
    func handleError(_ error: Error?)
    
}
