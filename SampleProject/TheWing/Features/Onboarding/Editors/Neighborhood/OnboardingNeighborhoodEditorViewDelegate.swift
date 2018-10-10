//
//  OnboardingNeighborhoodEditorViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 7/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol OnboardingNeighborhoodEditorViewDelegate: class {
    
    /// Displays neighborhood string.
    ///
    /// - Parameter neighborhood: Neighborhood string to display.
    func display(neighborhood: String)
    
    /// Called when the loading state changes.
    ///
    /// - Parameter loading: Determines if there is a network call loading.
    func isLoading(_ loading: Bool)
    
    /// Called when neighborhood information is successfully updated.
    func neighborhoodUpdated()
    
    /// Called when neighborhood information failed to update.
    ///
    /// - Parameter error: Error.
    func neighborhoodUpdateFailed(with error: Error?)
    
}
