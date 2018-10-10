//
//  UserExtension.swift
//  TheWing
//
//  Created by Luna An on 6/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension User {
    
    // MARK: - Public Properties
    
    /// Joined date of the user in format of "MMMM yyyy" (e.g. May 2018).
    var joinedDateString: String? {
        guard let dateObject = DateFormatter.date(from: createdAt, format: DateFormatConstants.serverDateFormat) else {
            return nil
        }
        return DateFormatter.dateString(from: dateObject, format: DateFormatConstants.dateJoinedFormat)
    }

}

// MARK: - AnalyticsRepresentable
extension User: AnalyticsRepresentable {
    
    var analyticsProperties: [String: Any] {
        var properties = profile.analyticsProperties
        properties[UserAnalyticsProperties.location.rawValue] = location?.name ?? AnalyticsConstants.notFilledOut
        return properties
    }
    
}
