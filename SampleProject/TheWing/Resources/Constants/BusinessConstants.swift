//
//  BusinessConstants.swift
//  TheWing
//
//  Created by Luna An on 3/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct BusinessConstants {
    
    // MARK: - Public Properties
    
    static let privacyPolicyURL = URL(string: "https://www.the-wing.com/privacy/")
    
    static let termsAndConditionsURL = URL(string: "https://www.the-wing.com/terms/")
    
    static let billingTeamEmailAddress = "billing@the-wing.com"
    
    static let contactEmailAddress = "sup@the-wing.com"

    static let loggedInContactEmailAddress = "membersonly@the-wing.com"
    
    static let forgotPasswordURL = URL(string: "https://witches.the-wing.com/forgot-password")
        
    static let bioCharacterCountLimit = 200

    static let defaultEventInterval: TimeInterval = 7200
    
    static let defaultPageSize = 25
    
    static let communityPageSize = 10
    
    static let defaultProfilePhotoURL = URL(string: "https://the-wing.imgix.net/app/wing-default-photo-4ba-8920b5666487.png")

    static let defaultRefreshInterval: TimeInterval = 1800

    static let reachabilityRefreshInterval: TimeInterval = 1800

    static let killSwitchErrorCode = 503

    static let forceUpgradeErrorCode = 403
    
}
