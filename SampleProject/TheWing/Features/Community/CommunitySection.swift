//
//  CommunitySection.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Sections for community tab's table view.
///
/// - topMatches: Top matches section.
/// - other: All other views.
enum CommunitySection: Int {
    case topMatches
    case other
    
    // MARK: - Public Properties
    
    /// All cases.
    static var all: [CommunitySection] = [.topMatches, .other]
}
