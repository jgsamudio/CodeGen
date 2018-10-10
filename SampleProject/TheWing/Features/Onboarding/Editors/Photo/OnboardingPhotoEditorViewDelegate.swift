//
//  OnboardingPhotoEditorViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 7/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol OnboardingPhotoEditorViewDelegate: ImagePickerDelegate {
    
    /// Sets placeholder image.
    func setPlaceholderImage()

    /// Displays a user profile image.
    ///
    /// - Parameter photoURL: Photo URL received from API.
    func displayPhoto(from photoURL: URL)
    
    /// Loading a user image from the api.
    ///
    /// - Parameter loading: Determines if the api call is loading.
    func loadingPhoto(loading: Bool)
    
    /// Called to show Next button.
    ///
    /// - Parameter show: True, if should show button, false otherwise.
    func showNextButton(show: Bool)
    
    /// Called when the loading state changes.
    ///
    /// - Parameter loading: Determines if there is a network call loading.
    func isLoading(_ loading: Bool)
    
    /// Called when user profile image is validated.
    func imageValidated()
    
    /// Displays an error when the profile with an image fails to update.
    ///
    /// - Parameter error: Error.
    func displayError(error: Error?)
    
}
