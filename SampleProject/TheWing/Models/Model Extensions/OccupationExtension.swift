//
//  OccupationExtension.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

extension Occupation {
    
    // MARK: - Public Properties
    
    /// Parameters
    var parameters: [String: Any] {
        var params = [String: Any]()
        params.insert(key: CodingKeys.position.rawValue, object: position)
        params.insert(key: CodingKeys.company.rawValue, object: company)
        return params
    }

    // MARK: - Public Functions
    
    /// Formatted text of the occupation model.
    ///
    /// - Returns: Formatted string of the position and company.
    func formattedText() -> String {
        var formattedString = position
        if let company = company {
            formattedString += " \("AT".localized(comment: "at")) \(company)"
        }
        return formattedString
    }

}

// MARK: - AnalyticsIdentifiable
extension Occupation: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        if let company = company {
            return "\(position) at \(company)"
        } else {
            return position
        }
    }
    
}

// MARK: - Equatable
extension Occupation: Equatable {
    
    static func == (lhs: Occupation, rhs: Occupation) -> Bool {
        return lhs.position == rhs.position && lhs.company == rhs.company
    }
    
}

// MARK: - Hashable
extension Occupation: Hashable {
    
    var hashValue: Int {
        return position.hashValue ^ (company ?? "").hashValue
    }

}
