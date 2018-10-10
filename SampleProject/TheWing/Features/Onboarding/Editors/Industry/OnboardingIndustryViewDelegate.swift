//
//  OnboardingIndustryViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 7/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol OnboardingIndustryViewDelegate: class {
    
    /// Displays the industries to present in the picker.
    ///
    /// - Parameters:
    ///   - industries: Industries to present.
    ///   - selectedIndex: Current selected index of the picker.
    func displayIndustries(industries: [String], selectedIndex: Int?)
    
    /// Loading industries from the api.
    ///
    /// - Parameter loading: Determines if the api call is loading.
    func loadingIndustries(loading: Bool)
    
    /// Called to show Next button.
    ///
    /// - Parameter show: True, if should show button, false otherwise.
    func showNextButton(show: Bool)
    
    /// Called when the loading state changes.
    ///
    /// - Parameter loading: Determines if there is a network call loading.
    func isLoading(_ loading: Bool)
    
    /// Called when industry information is successfully updated.
    func industryUpdated()
    
    /// Called when industry information failed to update.
    ///
    /// - Parameter error: Error if any.
    func industryUpdateFailed(with error: Error?)
    
}
