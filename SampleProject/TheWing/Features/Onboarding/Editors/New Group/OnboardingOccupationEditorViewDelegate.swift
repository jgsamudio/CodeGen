//
//  OnboardingOccupationEditorViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 7/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol OnboardingOccupationEditorViewDelegate: EditOccupationBaseDelegate {
    
    /// Called when the loading state changes.
    ///
    /// - Parameter loading: Determines if there is a network call loading.
    func isLoading(_ loading: Bool)
    
    /// Called when the occupation is successfully updated.
    func occupationsUpdated()
    
    /// Called when occupation information failed to update.
    ///
    /// - Parameter error: Error.
    func occupationsUpdateFailed(with error: Error?)
    
    /// Called to show Next button.
    ///
    /// - Parameter show: True, if should show button, false otherwise.
    func showNextButton(show: Bool)
    
}
