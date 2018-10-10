//
//  MemberSearchCategory.swift
//  TheWing
//
//  Created by Luna An on 8/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Member search category.
///
/// - unfiltered: Unfiltered.
/// - all: All.
/// - asks: Asks.
/// - offers: Offers.
enum MemberSearchCategory: Int {
    case unfiltered = 100
    case all = 0
    case asks = 1
    case offers = 2
    
    // MARK: - Public Properties
    
    /// Member search categories.
    static let searchCategories = [MemberSearchCategory.all,
                                   MemberSearchCategory.asks,
                                   MemberSearchCategory.offers]
    
    /// Localized search category title.
    var title: String {
        switch self {
        case .all:
            return MembersLocalization.allTitle
        case .asks:
            return MembersLocalization.asksTitle
        case .offers:
            return MembersLocalization.offersTitle
        default:
            return ""
        }
    }
    
    /// Associated member info type.
    var memberInfoType: MemberInfoType? {
        switch self {
        case .asks:
            return .asks
        case .offers:
            return .offers
        case .all:
            return .all
        default:
            return nil
        }
    }
    
    /// Query parameter to use in search request.
    var queryParam: String? {
        switch self {
        case .asks:
            return "asks"
        case .offers:
            return "offers"
        default:
            return nil
        }
    }

}
