//
//  EventBadgeType.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/25/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Event badge icon type.
enum EventBadgeType {
    case going
    case goingPlusOne
    case goingPlusTwo
    case goingPlusThree
    case goingPlusFour
    case waitlisted
    
    // MARK: - Public Properties
    
    /// Image representation of badge type.
    var image: UIImage {
        switch self {
        case .going:
            return #imageLiteral(resourceName: "going_badge")
        case .goingPlusOne:
            return #imageLiteral(resourceName: "going_1_badge")
        case .goingPlusTwo:
            return #imageLiteral(resourceName: "going_2_badge")
        case .goingPlusThree:
            return #imageLiteral(resourceName: "going_3_badge")
        case .goingPlusFour:
            return #imageLiteral(resourceName: "going_4_badge")
        case .waitlisted:
            return #imageLiteral(resourceName: "waitlisted_badge")
        }
    }
    
    /// Thumbnail image representation of badge type.
    var thumbnailImage: UIImage {
        switch self {
        case .going:
            return #imageLiteral(resourceName: "going_thumbnail")
        case .goingPlusOne:
            return #imageLiteral(resourceName: "going_1_thumbnail")
        case .goingPlusTwo:
            return #imageLiteral(resourceName: "going_2_thumbnail")
        case .goingPlusThree:
            return #imageLiteral(resourceName: "going_3_thumbnail")
        case .goingPlusFour:
            return #imageLiteral(resourceName: "going_4_thumbnail")
        case .waitlisted:
            return #imageLiteral(resourceName: "waitlisted_thumbnail")
        }
    }
    
    // MARK: - Public Functions
    
    /// Initializer that takes in event data object.
    ///
    /// - Parameter eventData: Event data.
    static func badgeFor(_ eventData: EventData) -> EventBadgeType? {
        if eventData.waitlisted {
            return .waitlisted
        } else if eventData.going {
            if let guestsData = eventData.guestsData {
                if guestsData.count == 1 {
                    return .goingPlusOne
                } else if guestsData.count == 2 {
                    return .goingPlusTwo
                } else if guestsData.count == 3 {
                    return .goingPlusThree
                } else if guestsData.count == 4 {
                    return .goingPlusFour
                } else {
                    return .going
                }
            } else {
                return .going
            }
        }
        
        return nil
    }

}
