//
//  HouseRule.swift
//  TheWing
//
//  Created by Paul Jones on 9/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Enum to represent a House Rule
enum HouseRule: Int {
    case checkIn = 0
    case eventAttendance
    case outsideFood
    case pets
    case guestPolicy
    case personalProperty
    
    // MARK: - Public Properties
    
    /// All the rules
    static var all: [HouseRule] = [
        .checkIn,
        .eventAttendance,
        .outsideFood,
        .pets,
        .guestPolicy,
        .personalProperty
    ]
    
    /// The rule's icon
    var icon: UIImage {
        switch self {
        case .checkIn:
            return #imageLiteral(resourceName: "house_rules_check_in")
        case .eventAttendance:
            return #imageLiteral(resourceName: "house_rules_event")
        case .outsideFood:
            return #imageLiteral(resourceName: "house_rules_food")
        case .pets:
            return #imageLiteral(resourceName: "house_rules_pets")
        case .guestPolicy:
            return #imageLiteral(resourceName: "house_rules_guests")
        case .personalProperty:
            return #imageLiteral(resourceName: "house_rules_personal_property")
        }
    }
    
    /// The rule's localized title.
    var localizedTitle: String {
        switch self {
        case .checkIn:
            return "HOUSE_RULES_TITLE_CHECK_IN".localized(comment: "Check in title")
        case .eventAttendance:
            return "HOUSE_RULES_TITLE_EVENT".localized(comment: "Event title")
        case .outsideFood:
            return "HOUSE_RULES_TITLE_FOOD".localized(comment: "Food title")
        case .pets:
            return "HOUSE_RULES_TITLE_PETS".localized(comment: "Pets title")
        case .guestPolicy:
            return "HOUSE_RULES_TITLE_GUEST".localized(comment: "Guests title")
        case .personalProperty:
            return "HOUSE_RULES_TITLE_PERSONAL_PROPERTY".localized(comment: "Personal property title")
        }
    }
    
    /// The rule's localized body.
    var localizedBody: String {
        switch self {
        case .checkIn:
            return "HOUSE_RULES_BODY_CHECK_IN".localized(comment: "Check in body")
        case .eventAttendance:
            return "HOUSE_RULES_BODY_EVENT".localized(comment: "Event body")
        case .outsideFood:
            return "HOUSE_RULES_BODY_FOOD".localized(comment: "Food body")
        case .pets:
            return "HOUSE_RULES_BODY_PETS".localized(comment: "Pets body")
        case .guestPolicy:
            return "HOUSE_RULES_BODY_GUEST".localized(comment: "Guests body")
        case .personalProperty:
            return "HOUSE_RULES_BODY_PERSONAL_PROPERTY".localized(comment: "Personal property body")
        }
    }

}
