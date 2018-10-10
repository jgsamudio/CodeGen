//
//  AttendeeCount.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct AttendeeCount: Codable {
    
    // MARK: - Public Properties
    
    let attendees: Int
    
    enum CodingKeys: String, CodingKey {
        case attendees = "attendees"
    }

}
