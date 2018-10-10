//
//  AnnouncementViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol AnnouncementViewDelegate: class {

    /// Notifies delegate to display announcement with given information.
    ///
    /// - Parameter data: Formatted announcement data.
    func displayAnnouncement(data: AnnouncementData)
    
}
