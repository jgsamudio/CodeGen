//
//  OnboardingBaseEditable.swift
//  TheWing
//
//  Created by Paul Jones on 7/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

typealias OnboardingBaseEditorViewControllerType = UIViewController & OnboardingBaseEditable

    // MARK: - Public Functions
    
func != (lhs: OnboardingBaseEditorViewControllerType, rhs: OnboardingBaseEditorViewControllerType) -> Bool {
    return lhs.hash != rhs.hash
}

/// This is the base class for any onboarding view controller, providing
/// a delegate for navigation, as well as convinience functions for moving
/// forward and back.
protocol OnboardingBaseEditable: class {
    
    // MARK: - Public Properties
    
    /// The delegate which enables navigation and updating progress. The functions below should invoke this delegate.
    /// The base editor controller gives you this functionality for free when you subclass it.
    var delegate: OnboardingBaseEditorViewControllerDelegate? { get set }
    
    /// How do we identify this screen to analytics?
    var analyticsIdentifier: String { get }
    
    /// What properties do you want to send to analytics?
    var analyticsProperties: [String: Any] { get }
    
    /// What step does this represent?
    var progressStep: OnboardingProgressStep? { get }

    // MARK: - Public Functions
    
    /// Request the container send the user to the next step.
    func goToNextStep()
    
    /// Request the container to send the user to the previous step.
    func goToPreviousStep()
    
    /// Request the container dismiss onboarding, likely only when onboarding is completed satisfactorily.
    func done()
    
    /// If you have any animation work to do for the intro, prepare it here. Will get called in
    /// `viewWillAppear`
    func prepareForIntroAnimation()
    
    /// This will get called in `viewDidAppear`, perform your intro animation.
    ///
    /// - Parameter completion: Tell me when you're done.
    func performIntroAnimation(with completion: @escaping (Bool) -> Void)
    
    /// If you have any animation work to do for your outro, prepare it here, will get called
    /// before the page view controller's pages get set to the next page.
    func prepareForOutroAnimation()
    
    /// Perform your animation here, and be _absolutely certain to call completion_,
    /// or the next page will not get set.
    ///
    /// CALL COMPLETION!
    func performOutroAnimation(with completion: @escaping (Bool) -> Void)
    
}
