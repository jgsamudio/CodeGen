//
//  ExternalURLConstants.swift
//  TheWing
//
//  Created by Ruchi Jain on 9/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct ExternalURLConstants {
    
    // MARK: - Public Functions
    
    /// Returns URL to open Apple Maps with given search term.
    ///
    /// - Parameter searchTerm: Search term to query map.
    /// - Returns: Optional URL.
    static func appleMaps(searchTerm: String) -> URL? {
        guard var components = URLComponents(string: "https://maps.apple.com") else {
            return nil
        }
        
    // MARK: - Public Properties
    
        let queryItem = URLQueryItem(name: "q", value: searchTerm)
        components.queryItems = [queryItem]
        return components.url
    }
    
    /// Returns URL to open Google Maps with given search term.
    ///
    /// - Parameter searchTerm: Search term to query map.
    /// - Returns: Optional URL.
    static func googleMaps(searchTerm: String) -> URL? {
        guard var components = URLComponents(string: "https://www.google.com/maps/search/") else {
            return nil
        }
        
        let queryItems = [URLQueryItem(name: "api", value: "1"), URLQueryItem(name: "query", value: searchTerm)]
        components.queryItems = queryItems
        return components.url
    }
    
    /// Returns URL to open Gmail with given email address.
    ///
    /// - Parameter address: Gmail address to send email to.
    /// - Returns: Optional URL.
    static func gmail(address: String, subject: String?) -> URL? {
        guard var components = URLComponents(string: "googlegmail:///co") else {
            return nil
        }

        var queryItems = [URLQueryItem(name: "to", value: address)]
        
        if let subject = subject {
            queryItems.append(URLQueryItem(name: "subject", value: subject))
        }
        
        components.queryItems = queryItems
        return components.url
    }
    
}
