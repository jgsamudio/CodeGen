//
//  ErrorLocalization.swift
//  TheWing
//
//  Created by Paul Jones on 7/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct ErrorLocalization {
    
    // MARK: - General

    // MARK: - Public Properties
    
    static let politeErrorTitle = "OOPS".localized(comment: "Polite error title.")
    
    // MARK: - URL
    
    static let invalidURLMessage = "CANNOT_OPEN_URL".localized(comment: "Message to display if app cannot open url.")
    
    // MARK: - Network Error
    
    static let networkErrorTitleText = "NETWORK_ERROR_TITLE".localized(comment: "The title for a network error.")
    
    static let networkErrorBodyText = "NETWORK_ERROR_BODY".localized(comment: "The body for a network error.")
    
    static let networkErrorActionText = "ALERT_CONFIRMATION_TITLE".localized(comment: "Action text for a network error.")

}

