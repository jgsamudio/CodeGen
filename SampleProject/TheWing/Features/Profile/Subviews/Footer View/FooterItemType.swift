//
//  FooterItemType.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Profile footer view type.
///
/// - neighborhood: Neighborhood type of the user.
/// - dateJoined: Date joined the wing type.
/// - starSign: Star sign of the user.
/// - location: Location of the user.
/// - birthday: Birthday of the user.
/// - email: Visible email of the user.
enum FooterItemType {
    case neighborhood(String?)
    case dateJoined(String)
    case starSign(String?)
    case location(String?)
    case birthday(String?)
    case email(String?)

    // MARK: - Public Properties
    
    /// Formatted text of the type.
    var formattedText: String? {
        switch self {
        case .neighborhood(let neighborhood):
            let addNeighborhoodText = "ADD_NEIGHBORHOOD".localized(comment: "Add Your Neighborhood")
            return neighborhood?.whitespaceTrimmedAndNilIfEmpty ?? addNeighborhoodText
        case .dateJoined(let dataString):
            return dataString
        case .starSign(let star):
            return star?.whitespaceTrimmedAndNilIfEmpty ?? "ADD_STAR_SIGN".localized(comment: "Add Your Star Sign")
        case .location(let location):
            return location ?? nil
        case .birthday(let birthday):
            return birthday?.whitespaceTrimmedAndNilIfEmpty ?? "ADD_BIRTHDAY".localized(comment: "Add Your Birthday")
        case .email(let email):
            return email?.whitespaceTrimmedAndNilIfEmpty ?? "ADD_EMAIL".localized(comment: "Add Your Email")
        }
    }

    /// The image of the footer item.
    var image: UIImage {
        switch self {
        case .neighborhood:
            return #imageLiteral(resourceName: "neighborhood_icon")
        case .dateJoined:
            return #imageLiteral(resourceName: "calendar_icon")
        case .starSign:
            return #imageLiteral(resourceName: "zodiac_icon")
        case .location:
            return #imageLiteral(resourceName: "homebase_icon")
        case .birthday:
            return #imageLiteral(resourceName: "birthday_icon")
        case .email:
            return #imageLiteral(resourceName: "email_icon")
        }
    }
    
    /// Indicates if the footer item is empty.
    var isEmpty: Bool {
        switch self {
        case .neighborhood(let neighborhood):
            return !String.isValidInput(neighborhood)
        case .starSign(let star):
            return !String.isValidInput(star)
        case .birthday(let birthday):
            return !String.isValidInput(birthday)
        case .email(let email):
            return !String.isValidInput(email)
        case .location(let location):
            return !String.isValidInput(location)
        default:
            return false
        }
    }

}
