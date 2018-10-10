//
//  AnnoucementsLocalization.swift
//  TheWing
//
//  Created by Paul Jones on 7/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct HomeLocalization {
    
    // MARK: - Public Properties
    
    static let announcementsAuthor = "THE_WING".localized(comment: "Announcements credited author")
    
    static let annoucementsTitle = "ANNOUCEMENTS_WING_THINGS".localized(comment: "Annoucements section, 'Wing things' text.")
    
    static let myHappeningsTitle = "MY_HAPPENINGS".localized(comment: "My Happenings")
    
    static let noUpcomingHappenings = "NO_UPCOMING_HAPPENINGS".localized(comment: "You don't have any upcoming...")
    
    static let bookmarkedHappeningsTitle = "**\("BOOKMARKED_HAPPENINGS".localized(comment: "Bookmarked Happenings"))**"
    
    static let myHappeningsHeaderSeeAllButtonTitle = "SEE_ALL".localized(comment: "See All")
    
    static let homeTabTitle = "HOME_TAB_TITLE".localized(comment: "Home")

    static let pullToRefreshTitle = "PULL_TO_REFRESH".localized(comment: "Pull To Refresh")
    
    // MARK: - Public Functions
    
    static func homeTabHeaderSubtitle(forMemberSince memberSince: String) -> String {
        return String(format: "HOME_TAB_HEADER_SUBTITLE".localized(comment: "Member since"), memberSince)
    }
    
    static let seeWhatsHappening = "SEE_WHATS_HAPPENING".localized(comment: "See What's Happening")
    
    static let homeTabHeaderEmptyTitle = "HOME_TAB_HEADER_EMPTY_TITLE".localized(comment: "Hi!")
    
    /// Returns the title of the tasks module given a count.
    ///
    /// - Parameter count: Count to display.
    /// - Returns: Localized string.
    static func tasksTitle(with count: Int) -> String {
        return String(format: "TASKS_WING_THINGS".localized(comment: "Tasks module title"), "\(count)")
    }
    
    /// Get the header title for username
    ///
    /// - Parameter username: the username
    /// - Returns: the localized string
    static func homeTabHeaderTitle(forUsername username: String) -> String {
        return String(format: "HOME_TAB_HEADER_TITLE".localized(comment: "Hi, user name!"), username)
    }
    
    /// Navigation title of the view controller.
    ///
    /// - Parameters:
    ///   - type: the type of the happning you want a string for
    ///   - count: Total count of the happenings
    /// - Returns: Formatted navigation title.
    static func navigationTitle(forType type: MyHappeningsType, andHappeningsCount count: Int?) -> String {
        switch type {
        case .myHappenings:
            let baseTitle = "\("MY_HAPPENINGS".localized(comment: "My Happenings"))"
            guard let totalCount = count else {
                return baseTitle
            }
            return "\(baseTitle) (\(totalCount))"
        case .bookmarkedHappenings:
            return "\("BOOKMARKS".localized(comment: "Bookmarks")) (\(count ?? 0))"
        }
    }
    
}
