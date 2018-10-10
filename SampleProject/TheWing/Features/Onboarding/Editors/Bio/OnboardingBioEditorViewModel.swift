//
//  OnboardingBasicsEditorViewModel.swift
//  TheWing
//
//  Created by Paul Jones on 7/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class OnboardingBioEditorViewModel {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: OnboardingBioEditorViewDelegate?
    
    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider

    private var initialBio: String?
    
    private var finalBio: String? {
        didSet {
            delegate?.setNextButton(enabled: finalBio?.isValidBio ?? true)
        }
    }
    
    private var updateState: OnboardingAnalyticsUpdate {
        return OnboardingAnalyticsUpdate.with(initial: initialBio, final: finalBio)
    }
    
    private var previouslyCompleted: Bool {
        return initialBio?.whitespaceTrimmed.nilIfEmpty != nil
    }
    
    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions

    /// Loads currently saved biography.
    func loadBiography() {
        let biography = dependencyProvider.networkProvider.sessionManager.user?.profile.biography?.whitespaceTrimmed
        delegate?.displayBiography(biography: biography ?? "")
        initialBio = biography
        finalBio = biography
    }
    
    /// Sends network request to update biography.
    @objc func uploadBiographyToProfile() {
        guard let user = dependencyProvider.networkProvider.sessionManager.user,
            user.profile.biography != finalBio ?? "" else {
            delegate?.biographyUpdated()
            return
        }
        
        delegate?.isLoading(loading: true)
        let fields = [ProfileParameterKey.bio.rawValue: finalBio ?? ""]
        dependencyProvider.networkProvider.userLoader.updateProfile(fields: fields) { [weak self] (result) in
            self?.delegate?.isLoading(loading: false)
            if result.isSuccess {
                self?.delegate?.biographyUpdated()
            } else {
                self?.delegate?.biographyUpdateFailed(with: result.error)
            }
        }
    }
    
    /// Reset these ready for use when the view subsequently gets shown again.
    func resetAnalyticsProperties() {
        initialBio = finalBio
    }

}

// MARK: - AnalyticsIdentifiable
extension OnboardingBioEditorViewModel: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.onboardingBio.analyticsIdentifier
    }
    
    var analyticsProperties: [String: Any] {
        return [
            AnalyticsEvents.Onboarding.stepName: analyticsIdentifier,
            AnalyticsEvents.Onboarding.stepPreviouslyCompleted: previouslyCompleted,
            AnalyticsEvents.Onboarding.stepUpdated: updateState.analyticsIdentifier
        ]
    }
    
}

// MARK: - EditBiographyViewDelegate
extension OnboardingBioEditorViewModel: EditBiographyViewDelegate {
    
    func biographyDidChange(_ text: String?) {
        finalBio = text?.whitespaceTrimmed
    }
    
}
