//
//  OnboardingSocialEditorViewModel.swift
//  TheWing
//
//  Created by Paul Jones on 7/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class OnboardingSocialEditorViewModel {
    
    // MARK: - Public Properties
    
    weak var delegate: OnboardingSocialEditorViewDelegate?
    
    // MARK: - Private Properties
    
    private var dependencyProvider: DependencyProvider
    
    private var updateState: OnboardingAnalyticsUpdate = .none
    
    private var previouslyCompleted: Bool {
        return initialSocialFields.count > 0
    }
    
    private var initialSocialValues: Set<String> = Set()
    
    private var initialSocialFields: Set<SocialType> = Set()
    
    private var user: User? {
        return dependencyProvider.networkProvider.sessionManager.user
    }
    
    private var canSave: Bool = false {
        didSet {
            delegate?.setSaveShowing(canSave)
        }
    }
    
    private var validUpdate: Bool = true {
        didSet {
            delegate?.setSaveEnabled(validUpdate)
            canSave = !(editedProfile?.twitter?.isEmpty ?? true &&
                    editedProfile?.facebook?.isEmpty ?? true &&
                    editedProfile?.instagram?.isEmpty ?? true &&
                    editedProfile?.website?.isEmpty ?? true)
        }
    }
    
    private var editedProfile: EditableProfile? {
        didSet {
            validUpdate = editedProfile?.validTwitter ?? true &&
            editedProfile?.validFacebook ?? true &&
            editedProfile?.validWebsite ?? true &&
            editedProfile?.validInstagram ?? true
        }
    }
    
    // MARK: - Initialization
    
    init?(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions
    
    /// Populate the UI through the delegate by grabbing the information from the User object.
    func load() {
        guard let user = user else {
            return
        }
        
        editedProfile = EditableProfile(user: user)
        initialSocialValues = user.profile.socialValues
        initialSocialFields = user.profile.socialFields

        delegate?.displaySocialLinksView(website: editedProfile?.website,
                                         instagram: editedProfile?.instagram?.extractedUserName(),
                                         facebook: editedProfile?.facebook?.extractedUserName(),
                                         twitter: editedProfile?.twitter?.extractedUserName())
        
        delegate?.socialLinkValidityChanged(valid: editedProfile?.validFacebook ?? true, socialType: .facebook)
        delegate?.socialLinkValidityChanged(valid: editedProfile?.validInstagram ?? true, socialType: .instagram)
        delegate?.socialLinkValidityChanged(valid: editedProfile?.validTwitter ?? true, socialType: .twitter)
        delegate?.socialLinkValidityChanged(valid: editedProfile?.validWebsite ?? true, socialType: .web)
    }
    
    /// Attempts upload and tells delegate its completed.
    func upload() {
        guard wasEdited() else {
            updateState = .none
            delegate?.uploadCompleted(wasSuccessful: true, withError: nil)
            return
        }
        
        updateState = OnboardingAnalyticsUpdate.with(initialSocialValues: initialSocialValues,
                                                     initialSocialFields: initialSocialFields,
                                                     finalSocialValues: editedProfile!.socialValues,
                                                     finalSocialFields: editedProfile!.socialFields)

        var fields = [String: Any]()
        if websiteWasEdited() {
            fields[ProfileParameterKey.website.rawValue] = editedProfile?.website ?? ""
        }
        
        if instagramWasEdited() {
            fields[ProfileParameterKey.instagram.rawValue] = editedProfile?.instagram ?? ""
        }
        
        if twitterWasEdited() {
            fields[ProfileParameterKey.twitter.rawValue] = editedProfile?.twitter ?? ""
        }
        
        if facebookWasEdited() {
            fields[ProfileParameterKey.facebook.rawValue] = editedProfile?.facebook ?? ""
        }
       
        delegate?.isLoading(true)
        dependencyProvider.networkProvider.userLoader.updateProfile(fields: fields) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.delegate?.isLoading(false)
            strongSelf.delegate?.uploadCompleted(wasSuccessful: result.isSuccess, withError: result.error)
        }
    }
    
}

// MARK: - Private Functions
private extension OnboardingSocialEditorViewModel {
    
    func wasEdited() -> Bool {
        return websiteWasEdited() || instagramWasEdited() || twitterWasEdited() || facebookWasEdited()
    }
    
    func websiteWasEdited() -> Bool {
        return user?.profile.website?.whitespaceTrimmed ?? "" != editedProfile?.website ?? ""
    }
    
    func instagramWasEdited() -> Bool {
        let oldInstagram = user?.profile.instagram?.whitespaceTrimmed.extractedUserName()
        return oldInstagram ?? "" != editedProfile?.instagram?.extractedUserName() ?? ""
    }
    
    func twitterWasEdited() -> Bool {
        let oldTwitter = user?.profile.twitter?.whitespaceTrimmed.extractedUserName()
        return oldTwitter ?? "" != editedProfile?.twitter?.extractedUserName() ?? ""
    }
    
    func facebookWasEdited() -> Bool {
        let oldFacebook = user?.profile.facebook?.whitespaceTrimmed.extractedUserName()
        return oldFacebook ?? "" != editedProfile?.facebook?.extractedUserName() ?? ""
    }

}

// MARK: - EditSocialLinksDelegate
extension OnboardingSocialEditorViewModel: EditSocialLinksDelegate {
    
    func facebookUpdated(username: String?) {
        editedProfile?.facebook = String.facebookURL(with: username)
        delegate?.socialLinkValidityChanged(valid: editedProfile?.validFacebook ?? true, socialType: .facebook)
    }
    
    func instagramUpdated(username: String?) {
        editedProfile?.instagram = String.instagramURL(with: username)
        delegate?.socialLinkValidityChanged(valid: editedProfile?.validInstagram ?? true, socialType: .instagram)
    }
    
    func twitterUpdated(username: String?) {
        editedProfile?.twitter = String.twitterURL(with: username)
        delegate?.socialLinkValidityChanged(valid: editedProfile?.validTwitter ?? true, socialType: .twitter)
    }
    
    func websiteUpdated(link: String?) {
        editedProfile?.website = link?.whitespaceTrimmed
        delegate?.socialLinkValidityChanged(valid: editedProfile?.validWebsite ?? true, socialType: .web)
    }
    
}

// MARK: - AnalyticsIdentifiable
extension OnboardingSocialEditorViewModel: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.onboardingSocial.analyticsIdentifier
    }
    
    var analyticsProperties: [String: Any] {
        return [
            AnalyticsEvents.Onboarding.stepName: analyticsIdentifier,
            AnalyticsEvents.Onboarding.stepPreviouslyCompleted: previouslyCompleted,
            AnalyticsEvents.Onboarding.stepUpdated: updateState.analyticsIdentifier
        ]
    }
    
}

