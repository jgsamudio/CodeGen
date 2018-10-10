//
//  BookmarkStatusProvider.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class BookmarkStatusProvider {

    // MARK: - Public Properties

    weak var delegate: BookmarkStatusDelegate?

    // MARK: - Private Properties

    private let networkProvider: LoaderProvider

    private var eventCache: EventLocalCache {
        return networkProvider.eventLocalCache
    }

    // MARK: - Initialization

    init(networkProvider: LoaderProvider) {
        self.networkProvider = networkProvider
    }

    // MARK: - Public Functions

    /// Toggles the bookmark status of the event.
    ///
    /// - Parameter eventId: Id of the event.
    /// - Returns: Is it bookmarked?
    @discardableResult func toggleBookmarkStatus(eventId: String) -> Bool {
        let toggledBookmark = !eventCache.isBookmarked(eventId: eventId)

        networkProvider.eventsLoader.updateBookmark(eventId: eventId, toggled: toggledBookmark) { [weak self] (result) in
            result.ifFailure {
                self?.delegate?.handleError(result.error)
            }
        }
        
        delegate?.updateBookmark(eventId: eventId, status: toggledBookmark)
        return toggledBookmark
    }

    /// Bookmark info for the given id.
    ///
    /// - Parameter eventId: Id of the event.
    /// - Returns: Optional bookmark info.
    func bookmarkInfo(eventId: String) -> BookmarkInfo? {
        return eventCache.data[eventId]?.bookmarkedInfo
    }

}
