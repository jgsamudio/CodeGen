//
//  ProfileViewModel.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class ProfileViewModel {
    
    // MARK: - Public Properties

    /// Binding delegate for the view model.
    weak var delegate: ProfileViewDelegate?

    /// Determines if the profile if editable.
    var isEditable: Bool {
        return isMyProfile
    }
    
    // MARK: - Private Properties
    
    private let userId: String
    
    private let dependencyProvider: DependencyProvider
    
    private var isMyProfile: Bool {
        return dependencyProvider.networkProvider.sessionManager.user?.userId == userId
    }
    
    private var name: String!
    
    private var headline: String?
    
    private var imageURL: URL?
    
    private var links: [SocialLink] = []
    
    private var offersTags: [String]?
    
    private var asksTags: [String]?
    
    private var interestedInTags: [String]?

    /// User used to display data.
    private(set) lazy var user: User? = {
        return dependencyProvider.networkProvider.sessionManager.user
    }()

    private let partialMemberInfo: MemberInfo?
    
    // MARK: - Initialization
    
    init(userId: String, dependencyProvider: DependencyProvider, partialMemberInfo: MemberInfo?) {
        self.userId = userId
        self.dependencyProvider = dependencyProvider
        self.partialMemberInfo = partialMemberInfo
    }
    
    // MARK: - Public Functions
    
    /// Load user profile.
    func loadProfile() {
        loadPartialProfile()
        isMyProfile ? loadMyProfile() : loadProfile(with: userId)
    }
    
    /// Footer items.
    ///
    /// - Returns: Array of foot item types.
    func footerItems() -> [FooterItemType] {
        var items = [FooterItemType]()
        items.append(FooterItemType.neighborhood(user?.profile.neighborhood))
        items.append(FooterItemType.location(user?.location?.name))
        if let joinedDate = dateJoined(dateString: user?.joinedDateString) {
            items.append(FooterItemType.dateJoined(joinedDate))
        }
        let birthday = Birthday.decodeBirthday(birthday: user?.profile.birthday)
        items.append(FooterItemType.birthday(birthday?.formattedBirthdayString))
        
        if let starSign = StarSign(rawValue: user?.profile.star ?? "") {
            items.append(FooterItemType.starSign(starSign == .none ? nil : starSign.localizedDescription))
        } else {
            items.append(FooterItemType.starSign(nil))
        }
        items.append(FooterItemType.email(user?.profile.contactEmail))
        
        return items
    }

    /// Handles the action when a footer item is selected.
    ///
    /// - Parameter item: Footer type that was selected.
    func footerItemSelected(item: FooterItemType) {
        switch item {
        case .email(let email):
            if let email = email {
                delegate?.emailContactTapped(email: email)
            }
        default:
            return
        }
    }

}

// MARK: - Private Functions
private extension ProfileViewModel {
    
    func loadMyProfile() {
        user = dependencyProvider.networkProvider.sessionManager.user
        setProfile(with: user?.profile)
    }
    
    func loadProfile(with userId: String) {
        delegate?.hideAllEmptyViews()
        delegate?.isLoading(true)
        dependencyProvider.networkProvider.membersLoader.loadMember(memberId: userId) { [weak self] (result) in
            self?.delegate?.isLoading(false)
            result.ifSuccess {
                guard let user = result.value else {
                    return
                }
                self?.user = user
                self?.setProfile(with: user.profile)
            }
        }
    }

    func loadPartialProfile() {
        guard let partialMemberInfo = partialMemberInfo else {
            return
        }
        delegate?.displayNavigation(title: partialMemberInfo.name)
        delegate?.displayHeader(imageURL: partialMemberInfo.imageURL,
                                name: partialMemberInfo.name,
                                headline: partialMemberInfo.headline,
                                links: links)
    }
    
    func setProfile(with profile: Profile?) {
        guard let profile = profile else {
            return
        }
        
        setName(with: profile)
        setHeadline(with: profile)
        setImageURL(with: profile)
        setLinks(with: profile)
        delegate?.displayNavigation(title: name)
        delegate?.displayHeader(imageURL: imageURL, name: name, headline: headline, links: links)
        setOccupations(profile.occupations)
        setBio(profile.biography)
        setIndustry(profile.industry?.name)
        setOffers(with: profile)
        setlookingFor(with: profile)
        setInterests(with: profile)
        delegate?.displayFooter(items: footerItems(), showEmptyViews: isMyProfile)
    }
    
    func setName(with profile: Profile) {
       name = PersonNameComponentsFormatter.nameString(givenName: profile.name.first, familyName: profile.name.last)
    }
    
    func setHeadline(with profile: Profile) {
        if let headline = profile.headline, !headline.isEmpty {
            self.headline = headline
        }
    }
    
    func setImageURL(with profile: Profile) {
        if let urlString = profile.photo, urlString.isValidString {
            imageURL = URL(string: urlString)
        }
    }
    
    func setBio(_ bio: String?) {
        if let biography = bio, biography.isValidString {
            delegate?.displayBiography(biography: biography, activated: true)
        } else if isMyProfile {
            delegate?.displayEmptyBiography()
        } else if let name = user?.profile.name.first {
            let emptyDescription = String(format: "BIO_EMPTY".localized(comment: "Hasn't added biography"), name)
            delegate?.displayBiography(biography: emptyDescription, activated: false)
        }
    }
    
    func setIndustry(_ industry: String?) {
        if let industry = industry, industry.isValidString {
            delegate?.displayIndustry(industry: industry, activated: true)
        } else if isMyProfile {
            delegate?.displayEmptyIndustry()
        } else if let name = user?.profile.name.first {
            let emptyDescription = String(format: "INDUSTRY_EMPTY".localized(comment: "Hasn't added industry"), name)
            delegate?.displayIndustry(industry: emptyDescription, activated: false)
        }
    }
    
    func setOffers(with profile: Profile) {
        offersTags = profile.offers?.filter { !$0.whitespaceTrimmed.isEmpty }
        if let offers = offersTags, !offers.isEmpty {
            delegate?.displayOffersTags(offers: offers.map { $0.capitalized }.sorted(),
                                        descriptionText: nil,
                                        activated: true)
        } else if isMyProfile {
            delegate?.displayEmptyTags(type: .offers(TagData(isSelectable: false, isRemovable: false)))
        } else if let name = user?.profile.name.first {
            let emptyDescription = String(format: "OFFERS_EMPTY".localized(comment: "Offers section empty title"), name)
            delegate?.displayOffersTags(offers: [], descriptionText: emptyDescription, activated: false)
        }
    }
    
    func setlookingFor(with profile: Profile) {
        asksTags = profile.asks?.filter { !$0.whitespaceTrimmed.isEmpty }
        if let lookingFor = asksTags, !lookingFor.isEmpty {
            delegate?.displayLookingForTags(lookingFor: lookingFor.map { $0.capitalized }.sorted(),
                                            descriptionText: nil,
                                            activated: true)
        } else if isMyProfile {
            delegate?.displayEmptyTags(type: .asks(TagData(isSelectable: false, isRemovable: false)))
        } else if let name = user?.profile.name.first {
            let emptyDescription = String(format: "ASKS_EMPTY".localized(comment: "Asks section empty title"), name)
            delegate?.displayLookingForTags(lookingFor: [], descriptionText: emptyDescription, activated: false)
        }
    }
    
    func setInterests(with profile: Profile) {
        interestedInTags = profile.interests?.filter { !$0.whitespaceTrimmed.isEmpty }
        if let interests = interestedInTags, !interests.isEmpty {
            delegate?.displayInterestsTags(interests: interests.map { $0.capitalized }.sorted(),
                                           descriptionText: nil,
                                           activated: true)
        } else if isMyProfile {
            delegate?.displayEmptyTags(type: .interests(TagData(isSelectable: false, isRemovable: false)))
        } else if let name = user?.profile.name.first {
            let emptyDescription = String(format: "INTERESTS_EMPTY".localized(comment: "Interests section empty title"),
                                          name)
            delegate?.displayInterestsTags(interests: [], descriptionText: emptyDescription, activated: false)
        }
    }

    func setLinks(with provider: SocialLinkProvider?) {
        guard let provider = provider else {
            return
        }
        links = []
        setLink(with: provider.website, for: .web)
        setLink(with: provider.facebook, for: .facebook)
        setLink(with: provider.instagram, for: .instagram)
        setLink(with: provider.twitter, for: .twitter)
    }
    
    func setLink(with string: String?, for linkType: SocialType) {
        guard let string = string, !string.isEmpty, let url = URL(string: string) else {
            return
        }
        
        let link = SocialLink(url: url, icon: linkType.image(), isUniversalLink: linkType.universalLinkAvailable)
        links.append(link)
    }
    
    func dateJoined(dateString: String?) -> String? {
        guard let joinedDate = user?.joinedDateString, joinedDate.isValidString else {
            return nil
        }
        
       return "\("JOINED".localized(comment: "Joined")): \(joinedDate)"
    }
    
    func setOccupations(_ occupations: [Occupation]?) {
        if !(occupations?.isEmpty ?? true) {
            let occupationString = occupations?.compactMap { $0.formattedText() }.joined(separator: "\n")
            delegate?.displayCurrentOccupation(occupation: occupationString,
                                               headline: occupationHeadline(occupations: occupations),
                                               activated: true)
        } else if let name = user?.profile.name.first, !isMyProfile {
            let currentOccupationEmpty = "CURRENT_OCCUPATION_EMPTY".localized(comment: "Hasn't added current occupation")
            let emptyDescription = String(format: currentOccupationEmpty, name)
            delegate?.displayCurrentOccupation(occupation: emptyDescription,
                                               headline: occupationHeadline(occupations: nil),
                                               activated: false)
        }
    }

    func occupationHeadline(occupations: [Occupation]?) -> String {
        if (occupations?.count ?? 0) > 1 {
            return "CURRENT_OCCUPATIONS".localized(comment: "Current occupations")
        } else {
            return "CURRENT_OCCUPATION".localized(comment: "Current occupation")
        }
    }
    
}
