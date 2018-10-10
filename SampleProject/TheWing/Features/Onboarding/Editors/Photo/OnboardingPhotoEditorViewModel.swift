//
//  OnboardingPhotoEditorViewModel.swift
//  TheWing
//
//  Created by Luna An on 7/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class OnboardingPhotoEditorViewModel {

    // MARK: - Public Properties

    /// Binding delegate for the view model.
    weak var delegate: OnboardingPhotoEditorViewDelegate?

    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider
    
    private var userLoader: ProfileLoader {
        return dependencyProvider.networkProvider.userLoader
    }
    
    private var showNext: Bool = false {
        didSet {
            delegate?.showNextButton(show: showNext)
        }
    }
    
    private var newImageData: Data?
    
    private var newImageUrl: String?
    
    private var previouslyCompleted: Bool = false
    
    private var finalStateChangedPhoto: Bool = false
    
    private var updateState: OnboardingAnalyticsUpdate {
        return OnboardingAnalyticsUpdate.with(initial: previouslyCompleted, final: finalStateChangedPhoto)
    }
    
    // MARK: - Initialization

    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions

    /// Loads profile image.
    func loadProfileImage() {
        guard let photo = dependencyProvider.networkProvider.sessionManager.user?.profile.photo,
            let photoURL = URL(string: photo), photoURL != BusinessConstants.defaultProfilePhotoURL else {
                delegate?.setPlaceholderImage()
                previouslyCompleted = false
                return
        }
        previouslyCompleted = true
        delegate?.displayPhoto(from: photoURL)
    }
    
    /// Updates profile with new image data if available.
    func updateProfile() {
        guard let imageData = newImageData else {
            showNext = true
            delegate?.imageValidated()
            return
        }
        updateProfileImage(with: imageData)
    }
    
    /// Sets new image data.
    ///
    /// - Parameter newImageData: New image data.
    func set(newImageData: Data) {
        self.newImageData = newImageData
        showNext = true
    }
    
    /// Reset these ready for use when the view subsequently gets shown again.
    func resetAnalyticsProperties() {
        previouslyCompleted = true /// if they get past, then they have a photo
        finalStateChangedPhoto = false
    }

}

// MARK: - Private Functions
private extension OnboardingPhotoEditorViewModel {
    
    func updateProfileImage(with imageData: Data) {
        delegate?.isLoading(true)
        userLoader.upload(avatar: imageData, result: { (result) in
            if let result = result {
                self.updateImageUrl(result, completion: {
                    self.uploadProfile()
                })
            } 
        }) { (error) in
            self.delegate?.isLoading(false)
            self.delegate?.displayError(error: error)
        }
    }
    
    func updateImageUrl(_ result: [String: Any], completion: () -> Void) {
        if let imageUrl = result["response"] as? String {
            newImageUrl = imageUrl
            completion()
        }
    }
    
    func uploadProfile() {
        guard let user = dependencyProvider.networkProvider.sessionManager.user,
            let imageURL = newImageUrl, imageURL != user.profile.photo else {
            return
        }
        
        let fields = [ProfileParameterKey.photo.rawValue: imageURL]
        userLoader.updateProfile(fields: fields) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.isLoading(false)
            if result.isSuccess {
                strongSelf.finalStateChangedPhoto = true
                strongSelf.delegate?.imageValidated()
            } else {
                strongSelf.delegate?.displayError(error: result.error)
            }
        }
        
    }

}

// MARK: - AnalyticsIdentifiable
extension OnboardingPhotoEditorViewModel: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.onboardingPhoto.analyticsIdentifier
    }
    
    var analyticsProperties: [String: Any] {
        return [
            AnalyticsEvents.Onboarding.stepName: analyticsIdentifier,
            AnalyticsEvents.Onboarding.stepPreviouslyCompleted: previouslyCompleted,
            AnalyticsEvents.Onboarding.stepUpdated: updateState.analyticsIdentifier
        ]
    }
    
}
