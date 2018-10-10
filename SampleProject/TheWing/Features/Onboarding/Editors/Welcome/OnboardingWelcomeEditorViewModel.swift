//
//  OnboardingWelcomeEditorViewModel.swift
//  TheWing
//
//  Created by Luna An on 7/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class OnboardingWelcomeEditorViewModel {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: OnboardingWelcomeEditorViewDelegate?
        
    /// User's first name.
    let userName: String

    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider
    
    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
        userName = dependencyProvider.networkProvider.sessionManager.user?.profile.name.first ?? ""
    }

    // MARK: - Public Functions
    
    /// Called when the action button is tapped to start the onboarding process.
    @objc func onboardingStarted() {
        delegate?.onboardingStarted()
    }
    
}
