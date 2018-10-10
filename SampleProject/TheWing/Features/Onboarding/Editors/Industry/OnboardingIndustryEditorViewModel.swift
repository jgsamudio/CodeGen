//
//  OnboardingIndustryEditorViewModel.swift
//  TheWing
//
//  Created by Luna An on 7/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingIndustryEditorViewModel {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: OnboardingIndustryViewDelegate?

    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider
    
    private var newIndustry: Industry? {
        didSet {
            showNext = newIndustry != nil
        }
    }
    
    private var industries: [Industry]?
    
    private var showNext: Bool = false {
        didSet {
            delegate?.showNextButton(show: showNext)
        }
    }
    
    private var initialIndustry: Industry?
    
    private var previouslyCompleted: Bool = false
    
    private var updateState: OnboardingAnalyticsUpdate {
        return OnboardingAnalyticsUpdate.with(initial: initialIndustry?.name, final: newIndustry?.name)
    }
    
    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
        previouslyCompleted = dependencyProvider.networkProvider.sessionManager.user?.profile.industry != nil
    }
    
    // MARK: - Public Functions

    /// Sets the industry of the editable profile.
    ///
    /// - Parameter industry: User industry to set to.
    func set(industry: String) {
        guard let industries = industries?.nilIfEmpty,
            let filteredIndustries = (industries.filter { $0.name == industry }).nilIfEmpty else {
                return
        }
        newIndustry = filteredIndustries[0]
    }
    
    /// Loads industries from api.
    func loadIndustries() {
        delegate?.loadingIndustries(loading: true)
        initialIndustry = dependencyProvider.networkProvider.sessionManager.user?.profile.industry
        dependencyProvider.networkProvider.userLoader.loadIndustries { [weak self] (result) in
            self?.delegate?.loadingIndustries(loading: false)
            result.ifSuccess {
                guard let industries = result.value?.nilIfEmpty else {
                    return
                }
                self?.updateIndustryData(industries: industries)
            }
            result.ifFailure {
                self?.updateIndustryData(industries: Industry.defaults)
            }
        }
    }
    
    /// Uploads industry to user profile.
    @objc func uploadIndustryToProfile() {
        guard let user = dependencyProvider.networkProvider.sessionManager.user,
            let newIndustry = newIndustry,
            user.profile.industry != newIndustry else {
            delegate?.industryUpdated()
            return
        }
        
        delegate?.isLoading(true)
        let fields = [ProfileParameterKey.industry.rawValue: newIndustry.parameters]
        dependencyProvider.networkProvider.userLoader.updateProfile(fields: fields) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.isLoading(false)
            if result.isSuccess {
                strongSelf.delegate?.industryUpdated()
            } else {
                strongSelf.delegate?.industryUpdateFailed(with: result.error)
            }
        }
    }
    
    /// Reset these ready for use when the view subsequently gets shown again.
    func resetAnalyticsProperties() {
        initialIndustry = newIndustry
    }

}

// MARK: - Private Functions
private extension OnboardingIndustryEditorViewModel {
    
    func updateIndustryData(industries: [Industry]) {
        self.industries = industries
        var selectedIndex: Int?
        if let industry = dependencyProvider.networkProvider.sessionManager.user?.profile.industry {
            selectedIndex = industries.index(of: industry)
            showNext = selectedIndex != nil
        }
        delegate?.displayIndustries(industries: industries.map { $0.name }, selectedIndex: selectedIndex)
    }
    
}

// MARK: - AnalyticsIdentifiable
extension OnboardingIndustryEditorViewModel: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.onboardingIndustry.analyticsIdentifier
    }
    
    var analyticsProperties: [String: Any] {
        return [
            AnalyticsEvents.Onboarding.stepName: analyticsIdentifier,
            AnalyticsEvents.Onboarding.stepPreviouslyCompleted: previouslyCompleted,
            AnalyticsEvents.Onboarding.stepUpdated: updateState.analyticsIdentifier
        ]
    }
    
}
