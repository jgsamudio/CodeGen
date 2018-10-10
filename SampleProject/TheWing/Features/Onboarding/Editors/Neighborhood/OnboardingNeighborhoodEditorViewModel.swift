//
//  OnboardingNeighborhoodEditorViewModel.swift
//  TheWing
//
//  Created by Luna An on 7/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class OnboardingNeighborhoodEditorViewModel {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: OnboardingNeighborhoodEditorViewDelegate?
    
    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider

    private var initialNeighborhood: String?
    
    private var finalNeighborhood: String?
    
    private var updateState: OnboardingAnalyticsUpdate {
        return OnboardingAnalyticsUpdate.with(initial: initialNeighborhood, final: finalNeighborhood)
    }
    
    private var completed: Bool {
        return initialNeighborhood?.nilIfEmpty != nil || finalNeighborhood?.nilIfEmpty != nil
    }

    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions
    
    /// Loads neighborhood.
    func loadNeighborhood() {
        guard let neighborhood = dependencyProvider.networkProvider.sessionManager.user?.profile.neighborhood else {
            return
        }

        initialNeighborhood = neighborhood
        finalNeighborhood = neighborhood

        delegate?.display(neighborhood: neighborhood)
    }
    
    /// Set the new neighborhood on this view model.
    ///
    /// - Parameter neigborhood: The new neighborhood.
    func set(neighborhood: String) {
        finalNeighborhood = neighborhood
    }
    
    /// Uploads neighborhood to user profile.
    @objc func uploadNeighborhoodToProfile() {
        if let initialNeighborhood = initialNeighborhood, let finalNeighborhood = finalNeighborhood {
            if initialNeighborhood == finalNeighborhood {
                delegate?.neighborhoodUpdated()
                return
            }
        }

        guard let user = dependencyProvider.networkProvider.sessionManager.user,
                user.profile.neighborhood != finalNeighborhood else {
                delegate?.neighborhoodUpdated()
                return
        }

        delegate?.isLoading(true)
        let fields = [ProfileParameterKey.neighborhood.rawValue: finalNeighborhood ?? ""]
        dependencyProvider.networkProvider.userLoader.updateProfile(fields: fields) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.isLoading(false)
            if result.isSuccess {
                strongSelf.delegate?.neighborhoodUpdated()
            } else {
                strongSelf.delegate?.neighborhoodUpdateFailed(with: result.error)
            }
        }
    }
    
    /// Updates profile with new neighborhood information.
    @objc func updateProfile() {
        delegate?.neighborhoodUpdated()
    }
    
    /// Reset these ready for use when the view subsequently gets shown again.
    func resetAnalyticsProperties() {
        initialNeighborhood = finalNeighborhood
    }
    
}

// MARK: - AnalyticsIdentifiable
extension OnboardingNeighborhoodEditorViewModel: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.onboardingNeighborhood.analyticsIdentifier
    }
    
    var analyticsProperties: [String: Any] {
        return [
            AnalyticsEvents.Onboarding.stepName: analyticsIdentifier,
            AnalyticsEvents.Onboarding.stepPreviouslyCompleted: completed,
            AnalyticsEvents.Onboarding.stepUpdated: updateState.analyticsIdentifier
        ]
    }
    
}
