//
//  AnnouncementData.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct AnnouncementData {
    
    // MARK: - Public Properties
    
    /// Announcement identifier.
    let identifier: String
    
    /// Post author.
    let author: String
    
    /// String describing time since post was made.
    let timePosted: String
    
    /// Post body.
    let description: String
    
    /// Post title.
    let title: String?
    
    /// Post image url.
    let imageURL: URL?
    
    /// Author image url.
    let authorImageURL: URL?
    
    // MARK: - Initialization
    
    /// Instantiates an announcement data object given raw announcment data.
    ///
    /// - Parameter announcement: Announcement.
    init(announcement: Announcement) {
        identifier = announcement.postId
        author = HomeLocalization.announcementsAuthor
        description = announcement.description
        
        if let announcementTitle = announcement.title {
            title = announcementTitle.isEmpty ? nil : announcementTitle
        } else {
            title = nil
        }
        
        if let date = DateFormatter.date(from: announcement.createdAt, format: DateFormatConstants.serverDateFormat) {
            timePosted = Date.timeSinceString(from: date)
        } else {
            timePosted = ""
        }
        
        if let urlString = announcement.imageUrl, let imageURL = URL(string: urlString) {
            self.imageURL = imageURL
        } else {
            imageURL = nil
        }
        
        if let urlString = announcement.posterIcon, let imageURL = URL(string: urlString) {
            authorImageURL = imageURL
        } else {
            authorImageURL = nil
        }
    }
    
}
