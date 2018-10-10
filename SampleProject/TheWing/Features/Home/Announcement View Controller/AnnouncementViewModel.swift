//
//  AnnouncementViewModel.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class AnnouncementViewModel {

    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: AnnouncementViewDelegate?

    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider

    private let announcement: AnnouncementData
    
    // MARK: - Initialization
    
    /// Initializes an announcements view model object.
    ///
    /// - Parameters:
    ///   - announcement: Announcement data object.
    ///   - dependencyProvider: Dependency provider.
    init(announcement: AnnouncementData, dependencyProvider: DependencyProvider) {
        self.announcement = announcement
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions
    
    /// Loads announcement and formats data.
    func loadAnnouncement() {
        delegate?.displayAnnouncement(data: announcement)
    }
    
}
