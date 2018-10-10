//
//  OnboardingBasicsEditorViewDelegate.swift
//  TheWing
//
//  Created by Paul Jones on 7/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol OnboardingBioEditorViewDelegate: class {

    /// The view controller should display the biography.
    ///
    /// - Parameter biography: The biography text.
    func displayBiography(biography: String)
    
    /// The validity of the bio has changed, update your view accordingly.
    ///
    /// - Parameter show: Show or not show boolean.
    func setNextButton(enabled: Bool)
    
    /// The view controller should indicate to the user that the network has been hit.
    ///
    /// - Parameter loading: Is the network call under way?
    func isLoading(loading: Bool)
    
    /// The biography has updated succesfully, continue.
    func biographyUpdated()
    
    /// The biography has failed to updated, show error.
    ///
    /// - Parameter error: The error you should show.
    func biographyUpdateFailed(with error: Error?)
    
}
