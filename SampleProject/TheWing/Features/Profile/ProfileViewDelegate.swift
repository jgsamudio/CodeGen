//
//  ProfileViewDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Profile view delegate.
protocol ProfileViewDelegate: class {

    /// Displays the profile header.
    ///
    /// - Parameters:
    ///   - imageURL: Avatar image view.
    ///   - name: Name of the user.
    ///   - headline: User headline.
    ///   - links: Social media links.
    func displayHeader(imageURL: URL?, name: String, headline: String?, links: [SocialLink])

    /// Displays the biography.
    ///
    /// - Parameters:
    ///   - biography: Biography to display.
    ///   - activated: Determines if the item is active. Used when viewing other profiles.
    func displayBiography(biography: String, activated: Bool)

    /// Displays the current occupation.
    ///
    /// - Parameters:
    ///   - occupation: Occupation to display.
    ///   - headline: Headline to display.
    ///   - activated: Determines if the item is active. Used when viewing other profiles.
    func displayCurrentOccupation(occupation: String?, headline: String, activated: Bool)

    /// Displays the current industry.
    ///
    /// - Parameters:
    ///   - industry: Industry to display.
    ///   - activated: Determines if the item is active. Used when viewing other profiles.
    func displayIndustry(industry: String, activated: Bool)

    /// Displays tags for Offers.
    ///
    /// - Parameters:
    ///   - offers: Tags for Offers.
    ///   - descriptionText: Text to display if the view is not active.
    ///   - activated: Determines if the item is active. Used when viewing other profiles.
    func displayOffersTags(offers: [String], descriptionText: String?, activated: Bool)

    /// Displays tags for Asks.
    ///
    /// - Parameters:
    ///   - lookingFor: Tags for Asks.
    ///   - descriptionText: Text to display if the view is not active.
    ///   - activated: Determines if the item is active. Used when viewing other profiles.
    func displayLookingForTags(lookingFor: [String], descriptionText: String?, activated: Bool)

    /// Displays tags for Interests.
    ///
    /// - Parameters:
    ///   - interests: Tags for Interests.
    ///   - descriptionText: Text to display if the view is not active.
    ///   - activated: Determines if the item is active. Used when viewing other profiles.
    func displayInterestsTags(interests: [String], descriptionText: String?, activated: Bool)

    /// Displays the empty biography view.
    func displayEmptyBiography()
    
    /// Displays the empty industry view.
    func displayEmptyIndustry()
    
    /// Displays the empty tags view.
    func displayEmptyTags(type: ProfileTagType)

    /// Displays the footer view.
    ///
    /// - Parameter items: Items to display.
    /// - Parameter showEmptyViews: Flag to determine if the footer should display empty footer items.
    func displayFooter(items: [FooterItemType], showEmptyViews: Bool)

    /// Displays the navigation view with the title provided.
    ///
    /// - Parameter title: Title of the navigation view.
    func displayNavigation(title: String)

    /// Hides all of the empty views of the profile.
    func hideAllEmptyViews()

    /// Indicates user tapped the contact via email button.
    func emailContactTapped(email: String)
    
    /// Notifies delegate that profile is being loaded.
    ///
    /// - Parameter loading: True, if is loading, false otherwise.
    func isLoading(_ loading: Bool)
    
}
