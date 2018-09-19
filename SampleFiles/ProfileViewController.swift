//
//  ProfileViewController.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Pilas
import DevKit

class ProfileViewController: BuildableViewController {
    
    // MARK: - Public Properties
    
    var viewModel: ProfileViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    /// Set the back button hidden
    var backButtonIsHidden: Bool {
        get {
            return backButton.isHidden
        }
        set {
            backButton.isHidden = newValue
        }
    }
    
    // MARK: - Private Properties

    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back_button"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonSelected), for: .touchUpInside)
        backButton.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        return backButton
    }()
    
    private lazy var navigationView: TransitioningNavigationView = {
        let subview = TransitioningNavigationView(theme: theme, backButton: backButton, barButtons: navigationBarButtons())
        subview.transitionColor = theme.colorTheme.invertPrimary
        return subview
    }()
    
    private lazy var subviewContainer: ProfileSubviewCollection = {
        return ProfileSubviewCollection(theme: theme, profileViewController: self)
    }()
    
    private lazy var scrollView: PilasScrollView = {
        let scrollView = PilasScrollView()
        scrollView.delegate = self
        view.insertSubview(scrollView, belowSubview: navigationView)
        let insets = UIEdgeInsets(top: navigationView.frame.maxY)
        scrollView.autoPinEdgesToSuperviewEdges(with: insets)
        return scrollView
    }()
    
    private lazy var activityIndicator = LoadingIndicator(activityIndicatorViewStyle: .gray)
    
    private lazy var dividerViews: [UIView] = {
        let views = [UIView(dividerWithDimension: .height, constant: 32),
                     UIView(dividerWithDimension: .height, constant: 32)]
        views.forEach { $0.backgroundColor = colorTheme.invertTertiary }
        return views
    }()
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        viewModel.loadProfile()
    }

}

// MARK: - Private Functions
private extension ProfileViewController {
    
    func setupDesign() {
        view.backgroundColor = theme.colorTheme.invertPrimary
        setupNavigationView()
        
        scrollView.insertView(view: subviewContainer.header)
        scrollView.insertView(view: dividerViews[0])
        
        scrollView.insertView(view: subviewContainer.biographyView)
        scrollView.insertView(view: subviewContainer.emptyBioView)
        
        scrollView.insertView(view: subviewContainer.currentOccupation)
        
        scrollView.insertView(view: subviewContainer.industryView)
        scrollView.insertView(view: subviewContainer.emptyIndustryView)
        
        scrollView.insertView(view: subviewContainer.offersView)
        scrollView.insertView(view: subviewContainer.emptyOffersView)
        
        scrollView.insertView(view: subviewContainer.asksView)
        scrollView.insertView(view: subviewContainer.emptyAsksView)
        
        scrollView.insertView(view: subviewContainer.interestsView)
        scrollView.insertView(view: subviewContainer.emptyInterestsView)
        
        scrollView.insertView(view: dividerViews[1])
        scrollView.insertView(view: subviewContainer.footerView)
        scrollView.insertDividerView(height: ViewConstants.bottomButtonHeight)
        
        view.addSubview(activityIndicator)
        activityIndicator.autoCenterInSuperview()
    }
    
    func setupNavigationView() {
        view.addSubview(navigationView)
        navigationView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        view.layoutIfNeeded()
    }

    func navigationBarButtons() -> [UIButton] {
        guard viewModel.isEditable else {
            return []
        }
        let editButton = UIButton()
        editButton.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        editButton.addTarget(self, action: #selector(editButtonSelected), for: .touchUpInside)
        let editButtonTitle = "EDIT_TITLE".localized(comment: "Edit title").uppercased()
        let textStyle = theme.textStyleTheme.buttonTitleTintRegular.withLineSpacing(0)
        editButton.setTitleText(editButtonTitle, using: textStyle)
        return [editButton]
    }
    
    @objc func backButtonSelected() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editButtonSelected() {
        let properties = currentUser?.analyticsProperties(forScreen: self, andAdditionalProperties: [
            AnalyticsConstants.ProfileCTA.key: AnalyticsConstants.ProfileCTA.editButton.analyticsIdentifier
        ])
        analyticsProvider.track(event: AnalyticsEvents.Profile.editButtonClicked.analyticsIdentifier,
                                properties: properties,
                                options: nil)
        presentEditProfile()
    }
    
}

extension ProfileViewController: ProfileViewDelegate {
    
    func isLoading(_ loading: Bool) {
        dividerViews.forEach { $0.isHidden = loading }
        activityIndicator.isLoading(loading: loading)
    }
    
    func displayHeader(imageURL: URL?, name: String, headline: String?, links: [SocialLink]) {
        subviewContainer.displayHeader(imageURL: imageURL, name: name, headline: headline, links: links)
    }
    
    func displayBiography(biography: String, activated: Bool) {
        subviewContainer.displayBiography(biography: biography, activated: activated)
    }
    
    func displayCurrentOccupation(occupation: String?, headline: String, activated: Bool) {
        subviewContainer.displayCurrentOccupation(occupation: occupation, headline: headline, activated: activated)
    }
    
    func displayIndustry(industry: String, activated: Bool) {
        subviewContainer.displayIndustry(industry: industry, activated: activated)
    }
    
    func displayOffersTags(offers: [String], descriptionText: String?, activated: Bool) {
        subviewContainer.displayOffersTags(offers: offers, descriptionText: descriptionText, activated: activated)
    }
    
    func displayLookingForTags(lookingFor: [String], descriptionText: String?, activated: Bool) {
        subviewContainer.displayLookingForTags(lookingFor: lookingFor,
                                               descriptionText: descriptionText,
                                               activated: activated)
    }
    
    func displayInterestsTags(interests: [String], descriptionText: String?, activated: Bool) {
        subviewContainer.displayInterestsTags(interests: interests, descriptionText: descriptionText, activated: activated)
    }
    
    func displayEmptyBiography() {
        subviewContainer.displayEmptyBiography()
    }
    
    func displayEmptyIndustry() {
        subviewContainer.displayEmptyIndustry()
    }
    
    func displayEmptyTags(type: ProfileTagType) {
        subviewContainer.displayEmptyTags(type: type)
    }

    func hideAllEmptyViews() {
        subviewContainer.hideAllEmptyViews()
    }
    
    func displayFooter(items: [FooterItemType], showEmptyViews: Bool) {
        subviewContainer.displayFooter(items: items, showEmptyViews: showEmptyViews)
    }
    
    func displayNavigation(title: String) {
        navigationView.set(title: title)
    }
    
    func presentEditProfile(entrySelection: EmptyStateViewType? = nil) {
        if let user = viewModel.user {
            let viewController = builder.editProfileViewController(user: user,
                                                                   delegate: self,
                                                                   entrySelection: entrySelection)
            present(viewController, animated: true, completion: nil)
        }
    }

    func emailContactTapped(url: URL) {
        UIApplication.shared.open(url: url)
    }
    
}

extension ProfileViewController: ProfileHeaderViewDelegate {
    
    func visit(_ url: URL) {
        open(url)
    }
    
}

extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let percent = max(min((yOffset / ViewConstants.navigationBarThreshold), 1), 0)
        navigationView.transition(percent: percent)
        
        let scrollViewAdjustedTopContentInset = scrollView.adjustedContentInset.top
        let headerViewNameOffset = yOffset - subviewContainer.header.nameLabel.frame.minY + scrollViewAdjustedTopContentInset
        let labelOffset = max(headerViewNameOffset, 0)
        navigationView.transitionLabel(offset: labelOffset)
    }
    
}

extension ProfileViewController: EditProfileDelegate {
    
    func editProfileCompleted() {
        navigationController?.navigationBar.isHidden = true
        viewModel.loadProfile()
        scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.adjustedContentInset.top), animated: false)
    }
    
}

extension ProfileViewController: EmptyStateViewDelegate {
    
    func emptyStateSelected(type: EmptyStateViewType) {
        presentEditProfile(entrySelection: type)
        let properties = currentUser?.analyticsProperties(forScreen: self, andAdditionalProperties: type.analyticsProperties)
        analyticsProvider.track(event: AnalyticsEvents.Profile.editButtonClicked.analyticsIdentifier,
                                properties: properties,
                                options: nil)
    }
    
}

extension ProfileViewController: ProfileFooterItemDelegate {
    
    func viewSelected(item: FooterItemType) {
        viewModel.footerItemSelected(item: item)
    }

}

extension ProfileViewController: AnalyticsIdentifiable {
    
    @objc var analyticsIdentifier: String {
        return AnalyticsScreen.profile.analyticsIdentifier
    }
    
}
