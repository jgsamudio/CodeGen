//
//  ProfileSubviewCollection.swift
//  TheWing
//
//  Created by Luna An on 7/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Collection of subviews used to remove some of the setup view code from the view controller.
final class ProfileSubviewCollection {
    
    // MARK: - Private Properties
    
    private let theme: Theme
    
    private weak var profileViewController: ProfileViewController?
    
    // MARK: - Initialization
    
    init(theme: Theme, profileViewController: ProfileViewController?) {
        self.theme = theme
        self.profileViewController = profileViewController
    }
    
    // MARK: - Public Properties
    
    /// Profile header view.
    lazy var header: ProfileHeaderView = {
        let header = ProfileHeaderView(theme: theme)
        header.delegate = profileViewController
        return header
    }()
    
    /// Profile offers section view.
    lazy var offersView: TagsSectionView = {
        let dataSource = ProfileTagType.offers(TagData(isSelectable: false, isRemovable: false))
        let tagsSectionView = TagsSectionView(theme: theme, title: dataSource.title)
        return tagsSectionView
    }()
    
    /// Profile asks section view.
    lazy var asksView: TagsSectionView = {
        let dataSource = ProfileTagType.asks(TagData(isSelectable: false, isRemovable: false))
        let tagsSectionView = TagsSectionView(theme: theme, title: dataSource.title)
        return tagsSectionView
    }()
    
    /// Profile interests section view.
    lazy var interestsView: TagsSectionView = {
        let dataSource = ProfileTagType.interests(TagData(isSelectable: false, isRemovable: false))
        let tagsSectionView = TagsSectionView(theme: theme, title: dataSource.title)
        return tagsSectionView
    }()
    
    /// Profile biography section view.
    lazy var biographyView = ProfileSectionTextView(theme: theme)
    
    /// Profile occupation section view.
    lazy var currentOccupation = ProfileSectionTextView(theme: theme)
    
    /// Profile industry section view.
    lazy var industryView = ProfileSectionTextView(theme: theme)
    
    /// Profile empty bio section view.
    lazy var emptyBioView = EmptyStateSectionView(theme: theme, type: .bio, delegate: profileViewController)
    
    /// Profile empty industrty section view.
    lazy var emptyIndustryView = EmptyStateSectionView(theme: theme, type: .industry, delegate: profileViewController)
    
    /// Profile empty offers section view.
    lazy var emptyOffersView = EmptyStateSectionView(theme: theme, type: .offers, delegate: profileViewController)
    
    /// Profile empty asks section view.
    lazy var emptyAsksView = EmptyStateSectionView(theme: theme, type: .asks, delegate: profileViewController)
    
    /// Profile empty interests section view.
    lazy var emptyInterestsView = EmptyStateSectionView(theme: theme, type: .interests, delegate: profileViewController)
    
    /// Profile footer view.
    lazy var footerView = ProfileFooterView(theme: theme, delegate: profileViewController)
    
    // MARK: - Public Functions

    /// Hides all empty views.
    func hideAllEmptyViews() {
        currentOccupation.isHidden = true
        
        industryView.isHidden = true
        emptyIndustryView.isHidden = true
        
        biographyView.isHidden = true
        emptyBioView.isHidden = true
        
        offersView.isHidden = true
        emptyOffersView.isHidden = true
        
        asksView.isHidden = true
        emptyAsksView.isHidden = true
        
        interestsView.isHidden = true
        emptyInterestsView.isHidden = true
    }
    
    /// Displays the profile header.
    ///
    /// - Parameters:
    ///   - imageURL: Avatar image view.
    ///   - name: Name of the user.
    ///   - headline: User headline.
    ///   - links: Social media links.
    func displayHeader(imageURL: URL?, name: String, headline: String?, links: [SocialLink]) {
        header.setImage(with: imageURL)
        header.setName(name)
        header.setHeadline(headline)
        header.setLinks(links)
    }
    
    /// Displays the biography.
    ///
    /// - Parameters:
    ///   - biography: Biography to display.
    ///   - activated: Determines if the item is active. Used when viewing other profiles.
    func displayBiography(biography: String, activated: Bool) {
        biographyView.isHidden = false
        emptyBioView.isHidden = true
        biographyView.setProfileTextView(title: "BIO".localized(comment: "Bio"), text: biography, activated: activated)
    }
    
    /// Displays the current occupation.
    ///
    /// - Parameters:
    ///   - occupation: Occupation to display.
    ///   - headline: Headline to display.
    ///   - activated: Determines if the item is active. Used when viewing other profiles.
    func displayCurrentOccupation(occupation: String?, headline: String, activated: Bool) {
        currentOccupation.isHidden = (occupation == nil)
        currentOccupation.setProfileTextView(title: headline, text: occupation, activated: activated)
    }
    
    /// Displays the current industry.
    ///
    /// - Parameters:
    ///   - industry: Industry to display.
    ///   - activated: Determines if the item is active. Used when viewing other profiles.
    func displayIndustry(industry: String, activated: Bool) {
        industryView.isHidden = false
        emptyIndustryView.isHidden = true
        industryView.setProfileTextView(title: "INDUSTRY".localized(comment: "Industry"),
                                        text: industry,
                                        activated: activated)
    }
    
    /// Displays tags for Offers.
    ///
    /// - Parameters:
    ///   - offers: Tags for Offers.
    ///   - descriptionText: Text to display if the view is not active.
    ///   - activated: Determines if the item is active. Used when viewing other profiles.
    func displayOffersTags(offers: [String], descriptionText: String?, activated: Bool) {
        offersView.isHidden = false
        emptyOffersView.isHidden = true
        let dataSource = ProfileTagType.offers((isSelectable: false, isRemovable: false))
        let dataSources = Array(repeating: dataSource, count: offers.count)
        offersView.setup(tags: offers, dataSources: dataSources, descriptionText: descriptionText, activated: activated)
    }
    
    /// Displays tags for Asks.
    ///
    /// - Parameters:
    ///   - lookingFor: Tags for Asks.
    ///   - descriptionText: Text to display if the view is not active.
    ///   - activated: Determines if the item is active. Used when viewing other profiles.
    func displayLookingForTags(lookingFor: [String], descriptionText: String?, activated: Bool) {
        asksView.isHidden = false
        emptyAsksView.isHidden = true
        let dataSource = ProfileTagType.asks((isSelectable: false, isRemovable: false))
        let dataSources = Array(repeating: dataSource, count: lookingFor.count)
        asksView.setup(tags: lookingFor, dataSources: dataSources, descriptionText: descriptionText, activated: activated)
    }
    
    /// Displays tags for Interests.
    ///
    /// - Parameters:
    ///   - interests: Tags for Interests.
    ///   - descriptionText: Text to display if the view is not active.
    ///   - activated: Determines if the item is active. Used when viewing other profiles.
    func displayInterestsTags(interests: [String], descriptionText: String?, activated: Bool) {
        interestsView.isHidden = false
        emptyInterestsView.isHidden = true
        let dataSource = ProfileTagType.interests((isSelectable: false, isRemovable: false))
        let dataSources = Array(repeating: dataSource, count: interests.count)
        interestsView.setup(tags: interests,
                            dataSources: dataSources,
                            descriptionText: descriptionText,
                            activated: activated)
    }
    
    /// Displays the empty biography view.
    func displayEmptyBiography() {
        biographyView.isHidden = true
        emptyBioView.isHidden = false
    }
    
    /// Displays the empty industry view.
    func displayEmptyIndustry() {
        industryView.isHidden = true
        emptyIndustryView.isHidden = false
    }
    
    /// Displays the empty tags view.
    func displayEmptyTags(type: ProfileTagType) {
        switch type {
        case .offers:
            offersView.isHidden = true
            emptyOffersView.isHidden = false
        case .asks:
            asksView.isHidden = true
            emptyAsksView.isHidden = false
        case .interests:
            interestsView.isHidden = true
            emptyInterestsView.isHidden = false
        }
    }
    
    /// Displays the footer view.
    ///
    /// - Parameter items: Items to display.
    /// - Parameter showEmptyViews: Flag to determine if the footer should display empty footer items.
    func displayFooter(items: [FooterItemType], showEmptyViews: Bool) {
        footerView.setupView(items: items, showEmptyViews: showEmptyViews)
    }
    
}
