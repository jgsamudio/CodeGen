//
//  OnboardingPages.swift
//  TheWing
//
//  Created by Paul Jones on 7/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingPages {
    
    // MARK: - Public Properties
    
    /// The view controller to show first.
    var first: OnboardingBaseEditorViewControllerType {
        return welcome
    }
    
    // MARK: - Private Properties
    
    private weak var delegate: OnboardingBaseEditorViewControllerDelegate?
    
    private var builder: Builder
    
    private lazy var pages: [OnboardingBaseEditorViewControllerType] = {
        return [
            welcome,
            basicsIntro,
            photo,
            occupation,
            industry,
            social,
            basicsCompleted,
            aboutYouIntro,
            interests,
            neighborhood,
            biography,
            aboutYouCompleted,
            asksOffersIntro,
            asks,
            offers,
            asksAndOffersCompleted,
            profile
        ]
    }()
    
    private lazy var pagesOnlyVisitedOnce: [OnboardingBaseEditorViewControllerType] = {
        return [welcome,
                basicsIntro,
                aboutYouIntro,
                asksOffersIntro,
                basicsCompleted,
                aboutYouCompleted,
                asksAndOffersCompleted]
    }()
    
    private lazy var welcome = builder.onboardingWelcomeViewController(delegate: delegate)
    
    private lazy var photo = builder.onboardingPhotoViewController(delegate: delegate)
    
    private lazy var occupation = builder.onboardingOccupationViewController(delegate: delegate)
    
    private lazy var industry = builder.onboardingIndustryViewController(delegate: delegate)
    
    private lazy var social = builder.onboardingSocialViewController(delegate: delegate)
    
    private lazy var neighborhood = builder.onboardingNeighborhoodViewController(delegate: delegate)
    
    private lazy var profile = builder.onboardingProfileViewController(delegate: delegate)
    
    private lazy var basicsCompleted = builder.onboardingStageCompletedViewController(delegate: delegate,
                                                                                      stage: .basics(.completed))
    
    private lazy var aboutYouCompleted = builder.onboardingStageCompletedViewController(delegate: delegate,
                                                                                        stage: .aboutYou(.completed))
    
    private lazy var asksAndOffersCompleted: OnboardingBaseEditorViewControllerType = {
        return builder.onboardingStageCompletedViewController(delegate: delegate,
                                                              stage: .asksAndOffers(.completed))
    }()
    
    private lazy var basicsIntro = builder.onboardingStageIntroViewController(delegate: delegate,
                                                                              stage: .basics(.inProgress))
    
    private lazy var aboutYouIntro = builder.onboardingStageIntroViewController(delegate: delegate,
                                                                                stage: .aboutYou(.inProgress))
    
    private lazy var asksOffersIntro = builder.onboardingStageIntroViewController(delegate: delegate,
                                                                                  stage: .asksAndOffers(.inProgress))
    
    private lazy var biography = builder.onboardingBioEditorViewController(delegate: delegate)
    
    private lazy var interests = builder.onboardingTagsEditorViewController(type: .interests(selected: false),
                                                                            delegate: delegate)
    
    private lazy var asks = builder.onboardingTagsEditorViewController(type: .asks(selected: false),
                                                                       delegate: delegate)
    
    private lazy var offers = builder.onboardingTagsEditorViewController(type: .offers(selected: false),
                                                                         delegate: delegate)
    
    // MARK: - Initialization
    
    init(builder: Builder, delegate: OnboardingBaseEditorViewControllerDelegate) {
        self.builder = builder
        self.delegate = delegate
    }
    
    // MARK: - Public Functions
    
    /// Get the view controller to show after the one you pass in as a paramter, be sure to call `finished` as well.
    ///
    /// - Parameter viewController: Which view controller do you want to go after?
    /// - Returns: The view controller to show now, or nil.
    subscript(after viewController: OnboardingBaseEditorViewControllerType) -> OnboardingBaseEditorViewControllerType? {
       if let index = (pages as [UIViewController]).index(of: viewController) {
                return pages[safe: index + 1]
        }
            
        return nil
    }
    
    /// Get the view controller before the on you're currently showing, to go back.
    ///
    /// - Parameter viewController: Which view controller do you want to go back from?
    /// - Returns: The view controller to show now, or nil.
    subscript(before viewController: OnboardingBaseEditorViewControllerType) -> OnboardingBaseEditorViewControllerType? {
        if let index = (pages as [UIViewController]).index(of: viewController) {
                return pages[safe: index - 1]
        }
            
        return nil
    }
    
    /// Gets you the first VC for the stage you pass in
    ///
    /// - Parameter stage: What stage do you want to jump to?
    subscript(forStage stage: OnboardingProgressStage) -> OnboardingBaseEditorViewControllerType? {
        switch stage {
        case .aboutYou:
            return interests
        case .asksAndOffers:
            return asks
        case .basics:
            return photo
        }
    }
    
    // MARK: - Public Functions
    
    /// You've finished with this view controller, this check makes sure that not intros or completions show twice.
    ///
    /// - Parameter viewController: Which view controller did you just finish with?
    func finished(with viewController: OnboardingBaseEditorViewControllerType) {
        if pagesOnlyVisitedOnce.contains(where: { $0 == viewController }) {
            if let index = (pages as [UIViewController]).index(of: viewController) {
                pages.remove(at: index)
            }
        }
    }
    
    /// Gives you the navigation direction for jumping from a VC to another VC, or nil if not allowed.
    ///
    /// - Parameters:
    ///   - fromEditor: Where are you coming from?
    ///   - toEditor: Where are you going to?
    /// - Returns: The navigation direction to use, or nil if it's not allowed.
    func navigationDirectionForTransition(fromEditor: OnboardingBaseEditorViewControllerType,
                                          toEditor: OnboardingBaseEditorViewControllerType)
        -> UIPageViewControllerNavigationDirection? {
            guard pagesOnlyVisitedOnce.index(where: { fromEditor == $0 }) == nil else {
                return nil
            }
            
            if let fromIndex = pages.index(where: { fromEditor == $0 }),
                let toIndex = pages.index(where: { toEditor == $0 }) {
                switch fromIndex.distance(to: toIndex) {
                case 0...:
                    return .forward
                default:
                    return .reverse
                }
            } else {
                return nil
            }
    }

}
