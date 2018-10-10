//
//  OnboardingOccupationEditorViewModel.swift
//  TheWing
//
//  Created by Luna An on 7/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class OnboardingOccupationEditorViewModel {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: OnboardingOccupationEditorViewDelegate?
    
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
    
    private var editableOccupations = EditableOccupations()
    
    private var headline: String?
    
    private var previouslyCompleted: Bool {
        return initialOccupationSet.count > 0
    }
    
    private var initialOccupationSet = Set<Occupation>()
    
    private var finalOccupationSet: Set<Occupation> {
        return editableOccupations.occupationsSet
    }
    
    private var updateState: OnboardingAnalyticsUpdate {
        return OnboardingAnalyticsUpdate.with(initialOccupations: initialOccupationSet, finalOccupations: finalOccupationSet)
    }
    
    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions
    
    /// Loads occupations.
    func loadOccupations() {
        if let occupations = dependencyProvider.networkProvider.sessionManager.user?.profile.occupations,
            !occupations.isEmpty {
            delegate?.displayOccupationItemView(occupations: occupations)
            editableOccupations.occupations = occupations
            initialOccupationSet = Set<Occupation>(occupations)
            showNext = true
        } else {
            delegate?.displayEmptyOccupationView()
            showNext = false
        }
        headline = dependencyProvider.networkProvider.sessionManager.user?.profile.headline
    }
    
    /// Updates the occupation view with newly configured occupations.
    ///
    /// - Parameters:
    ///   - occupation: The occupation to add/edit.
    ///   - originalOccupation: The original occupation to compare to.
    ///   - deleted: Flag if the delete action was requested.
    func updateOccupations(occupation: Occupation?, originalOccupation: Occupation?, deleted: Bool) {
        editableOccupations.updateOccupations(occupation: occupation,
                                              originalOccupation: originalOccupation,
                                              deleted: deleted,
                                              delegate: delegate)
        
        showNext = !editableOccupations.occupations.isEmpty
    }
    
    /// Updates profile.
    @objc func updateProfile() {
        guard let user = dependencyProvider.networkProvider.sessionManager.user else {
            return
        }
        
        if let headline = headline, headline.isValidString {
            guard user.profile.occupations != editableOccupations.occupations else {
                delegate?.occupationsUpdated()
                return
            }
            updateProfile(user: user)
        } else {
            configureHeadline()
            updateProfile(user: user)
        }
    }

    /// Reset these ready for use when the view subsequently gets shown again.
    func resetAnalyticsProperties() {
        initialOccupationSet = finalOccupationSet
    }

}

// MARK: - Private Functions
private extension OnboardingOccupationEditorViewModel {
    
    private func configureHeadline() {
        if let formattedOccupation = editableOccupations.occupations.first?.formattedText() {
            let headline = self.headline?.whitespaceTrimmedAndNilIfEmpty
            self.headline = headline == nil ? formattedOccupation : headline
        }
    }
    
    private func updateProfile(user: User) {
        delegate?.isLoading(true)
        var fields = [String: Any]()
        fields[ProfileParameterKey.headline.rawValue] = headline ?? ""
        fields[ProfileParameterKey.occupations.rawValue] = editableOccupations.occupations.map { $0.parameters }
        userLoader.updateProfile(fields: fields) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.isLoading(false)
            if result.isSuccess {
                strongSelf.delegate?.occupationsUpdated()
            } else {
                strongSelf.delegate?.occupationsUpdateFailed(with: result.error)
            }
        }
    }
    
}

// MARK: - AnalyticsIdentifiable
extension OnboardingOccupationEditorViewModel: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.onboardingOccupation.analyticsIdentifier
    }
    
    var analyticsProperties: [String: Any] {
        return [
            AnalyticsEvents.Onboarding.stepName: analyticsIdentifier,
            AnalyticsEvents.Onboarding.stepPreviouslyCompleted: previouslyCompleted,
            AnalyticsEvents.Onboarding.stepUpdated: updateState.analyticsIdentifier
        ]
    }
    
}

