//
//  EventMemberType.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import Marker

enum EventMemberType {
    case membersOnly
    case guest(numberOfGuests: Int)
    case fee(amount: Double)
    case preview(date: String?)

    // MARK: - Public Functions
    
    /// Member info generated string
    ///
    /// - Parameter types: Member types.
    /// - Returns: String of the member type.
    static func memberInfo(types: [EventMemberType]) -> String {
    
    // MARK: - Public Properties
    
        var memberInfoString = ""

        for type in types {
            let dot = (type.typeInfo() == types.last?.typeInfo()) ? "" : " \(ViewConstants.dot)"
            memberInfoString += "\(type.typeInfo())\(dot)"
        }

        return memberInfoString
    }

    private func typeInfo() -> String {
        switch self {
        case .membersOnly:
            return "MEMBERS_ONLY".localized(comment: "Members Only").uppercased()
        case .guest(let numberOfGuests):
            let guests = numberOfGuests > 1 ? "GUESTS".localized(comment: "Guests") : "GUEST".localized(comment: "Guest")
            let allowedString = "ALLOWED".localized(comment: "Allowed")
            return "\(numberOfGuests) \(guests) \(allowedString)".uppercased()
        case .fee(let amount):
            let feeString = EventStringFormatter.formatEventFee(amount) ?? "$\(amount)"
            return "\(feeString) \("FEE".localized(comment: "Fee"))".uppercased()
        case .preview(let date):
            if let dateString = date, !dateString.isEmpty {
                return "**\("RSVP_OPENS".localized(comment: "RSVP OPENS")) \(dateString)**".uppercased()
            } else {
                return "OPENS_SOON".localized(comment: "Opens soon")
            }
        }
    }

}
