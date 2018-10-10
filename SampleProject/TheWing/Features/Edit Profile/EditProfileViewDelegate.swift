//
//  EditProfileViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol EditProfileViewDelegate: EditProfileViewValidationDelegate, EditOccupationBaseDelegate, ErrorDelegate {

    /// Displays the profile image.
    func displayProfileImage(photo: String?)
    
    /// Displays the editable header info view.
    ///
    /// - Parameters:
    ///   - firstName: First name.
    ///   - lastName: Last name.
    ///   - headline: Headline.
    func displayHeaderInfoView(firstName: String, lastName: String, headline: String)

    /// Displays the biography.
    ///
    /// - Parameter biography: Biography.
    func displayBiography(_ biography: String?)
    
    /// Displays the empty occupation view.
    func displayEmptyOccupationView()

    /// Displays the occupation view with the given parameters.
    ///
    /// - Parameter occupations: Occupations to load.
    func displayOccupationItemView(occupations: [Occupation])
    
    /// Displays the social links view with optional prefilled text.
    ///
    /// - Parameters:
    ///   - website: Website.
    ///   - instagram: Instagram.
    ///   - facebook: Facebook.
    ///   - twitter: Twitter.
    func displaySocialLinksView(website: String?, instagram: String?, facebook: String?, twitter: String?)

    /// Displays the industries to present in the picker.
    ///
    /// - Parameters:
    ///   - industries: Industries to present.
    ///   - selectedIndex: Current selected index of the picker.
    func displayIndustries(industries: [String], selectedIndex: Int?)

    /// Displays the star signs to present in the picker.
    ///
    /// - Parameters:
    ///   - starSigns: Array of signs to present.
    ///   - selectedIndex: Current selected index of the picker.
    func displayStarSigns(starSigns: [String], selectedIndex: Int?)
    
    /// Displays birthday months and days to present in the picker.
    ///
    /// - Parameters:
    ///   - months: Months to display.
    ///   - days: Days to display.
    ///   - selectedDate: Selected date.
    func displayBirthday(months: [String], days: [String], selectedDate: Birthday?)
    
    /// Displays the interests for tags.
    ///
    /// - Parameter tags: Tags to display.
    func displayInterestTags(tags: [String]?)

    /// Displays the offers for tags.
    ///
    /// - Parameter tags: Tags to display.
    func displayOffersTags(tags: [String]?)

    /// Displays the looking for tags.
    ///
    /// - Parameter tags: Tags to display.
    func displayLookingForTags(tags: [String]?)
    
    /// Displays neighborhood string.
    ///
    /// - Parameter neighborhood: Neighborhood string to display.
    func display(neighborhood: String?)
    
    /// Displays email information.
    ///
    /// - Parameter email: Email information to display.
    func display(email: String?)

    /// Loading industries from the api.
    ///
    /// - Parameter loading: Determines if the api call is loading.
    func loadingIndustries(loading: Bool)
    
    /// Delegate to present discard alert.
    func presentDiscardAlert()
    
    /// Delegate for dismiss action.
    func dismissAction()

    /// Called when the loading state changes.
    ///
    /// - Parameter loading: Determines if there is a network call loading.
    func isLoading(loading: Bool)
    
    /// Called when the enabled property of save button should be changed.
    ///
    /// - Parameter enabled: True, if enabled. False, otherwise.
    func saveEnabledChanged(enabled: Bool)
    
}
