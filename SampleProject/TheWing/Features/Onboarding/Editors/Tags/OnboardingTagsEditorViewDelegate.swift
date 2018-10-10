//
//  OnboardingTagsEditorViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/25/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol OnboardingTagsEditorViewDelegate: class {
    
    /// Notifies delegate to refresh its collection.
    func refreshCollection()

    /// Notifies delegate that it should proceed.
    func proceed()
    
    /// Notifies delegate to display given error.
    ///
    /// - Parameter error: Error.
    func showError(_ error: Error?)
    
    /// Notifies delegate to display a loading indicator.
    ///
    /// - Parameter loading: True, if delegate should display, false otherwise.
    func isLoading(_ loading: Bool)

}
