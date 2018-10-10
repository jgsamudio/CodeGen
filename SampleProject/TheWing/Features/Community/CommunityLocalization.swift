//
//  CommunityLocalization.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct CommunityLocalization {
    
    // MARK: - Public Properties
    
    static let topMatches = "MATCHES".localized(comment: "Top Matches title")
    
    // MARK: - Public Functions
    
    /// Returns the call to action to see all top matches with count included.
    ///
    /// - Parameter count: Count.
    /// - Returns: Optional string.
    static func seeAllTopMatches(with count: Int) -> String? {
        return String(format: "SEE_ALL_COUNT".localized(comment: "See all (x)"), "\(count)")
    }
    
}
