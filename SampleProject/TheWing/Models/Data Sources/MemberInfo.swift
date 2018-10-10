//
//  MemberInfo.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct MemberInfo {
    
    // MARK: - Public Properties
    
    /// User Id.
    let userId: String
    
    /// Image URL.
    let imageURL: URL?
    
    /// Name.
    let name: String
    
    /// Headline.
    let headline: String?
    
    /// Industry.
    let industry: Industry?
    
    /// Homebase.
    let homebase: Location?
    
    /// Offers.
    let offers: [String]?
    
    /// Asks.
    let asks: [String]?
    
    /// Super match description.
    let superMatchDescription: String?
    
    // MARK: - Initialization
    
    init(member: Member) {
        userId = member.memberId
        imageURL = URL(string: member.avatar)
        name = "\(member.firstName) \(member.lastName)"
        headline = member.headline
        industry = member.industry
        homebase = member.location
        offers = member.offers
        asks = member.asks
        
        if let superMatch = member.superMatch, !superMatch.matchString.isEmpty {
            superMatchDescription = superMatch.matchString
            if let matchEmoji = superMatch.matchEmoji, !matchEmoji.isEmpty {
                let emojiString = String(unicodeNameString: matchEmoji)
                if !emojiString.isEmpty {
                    superMatchDescription?.append(" \(emojiString)")
                }
            }
        } else {
            superMatchDescription = nil
        }
    }
    
}

// MARK: - AnalyticsRepresentable
extension MemberInfo: AnalyticsRepresentable {
    
    var analyticsProperties: [String: Any] {
        let properties: [MemberInfoAnalyticsProperties: Any?] = [
            .photoFilled: imageURL != nil,
            .headlineFilled: headline != nil,
            .industry: industry?.name,
            .location: homebase?.analyticsIdentifier,
            .offerCount: offers?.count ?? 0,
            .askCount: asks?.count ?? 0,
            .superMatch: superMatchDescription != nil
        ]
        return properties.analyticsRepresentation
    }

}
