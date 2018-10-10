//
//  MembersLocalization.swift
//  TheWing
//
//  Created by Luna An on 8/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct MembersLocalization {
    
    // MARK: - Member Cell
    
    // MARK: - Public Properties
    
    static let memberCellOfferingTitle = "MEMBER_CELL_OFFERING_TITLE".localized(comment: "Offering:")
    
    static let memberCellAskingTitle = "MEMBER_CELL_ASKING_TITLE".localized(comment: "Asking:")
    
    // MARK: - Search
    
    static let allTitle = "ALL".localized(comment: "All")
    
    static let asksTitle = "ASKS".localized(comment: "Asks")
    
    static let offersTitle = "OFFERS".localized(comment: "Offers")
    
    // MARK: - Public Functions
    
    /// Text to display the members count.
    static func showMembersCountText(count: Int) -> String {
        return String(format: "SHOW_MEMBERS".localized(comment: "Show members"), "\(count)")
    }

}
