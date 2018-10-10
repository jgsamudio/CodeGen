//
//  EditProfileViewModel.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class EditProfileViewModel {

    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: EditProfileViewDelegate?

    /// Entry selection from the profile view controller.
    var entrySelection: EmptyStateViewType?

    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider

    private let user: User

    private var industries: [Industry]?
    
    private var editableOccupations = EditableOccupations()
    
    private var newImageData: Data?

    private var editableProfile: EditableProfile! {
        didSet {
            canSave = isValidUpdate
        }
    }
    
    private var canSave: Bool = false {
        didSet {
            delegate?.saveEnabledChanged(enabled: canSave)
        }
    }
    
    private var isEdited: Bool {
        return editableProfile != EditableProfile(user: user)
    }
    
    private var isValidUpdate: Bool {
        return editableProfile.validUpdate
    }
    
    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider, user: User, entrySelection: EmptyStateViewType?) {
        self.dependencyProvider = dependencyProvider
        self.user = user
        self.entrySelection = entrySelection
        editableProfile = EditableProfile(user: user)
    }

    // MARK: - Public Functions

    /// Loads the view of the edit profile.
    func loadUserProfile() {
        loadProfileImage()
        loadNames()
        loadBiography()
        loadOccupations()
        loadSocial()
        loadIndustries()
        loadTags()
        loadNeighborhood()
        loadStarSigns()
        loadBirthday()
        loadEmail()
    }

    /// Called when an attempt to discard changes was made.
    @objc func discardAttempt() {
        if isEdited {
            delegate?.presentDiscardAlert()
        } else {
            delegate?.dismissAction()
        }
    }

    /// Updates the profile with the current ediable profile object.
    @objc func updateProfile() {
        delegate?.isLoading(loading: true)
        if let imageData = newImageData {
          updateProfileWithAvatar(imageData)
        } else {
           uploadProfile()
        }
    }
    
    /// Sets the new avatar image of the user's profile.
    ///
    /// - Parameter newImageData: New avatar image to set to.
    func set(newImageData: Data) {
        self.newImageData = newImageData
        editableProfile.photo = "New Avatar"
    }
    
    /// Sets the industry of the editable profile.
    ///
    /// - Parameter industry: User industry to set to.
    func set(industry: String) {
        guard let industries = industries?.nilIfEmpty,
            let filteredIndustries = (industries.filter { $0.name == industry }).nilIfEmpty else {
            return
        }
        editableProfile.industry = filteredIndustries[0]
    }
    
    /// Sets the birthday month and day of the editable profile.
    ///
    /// - Parameters:
    ///   - birthdayMonth: User birthday month index to use.
    ///   - birthdayDay: User birthday day index to use.
    func set(birthdayMonth: Int?, birthdayDay: Int?) {
        let birthday = Birthday(month: birthdayMonth ?? 0, day: birthdayDay ?? 0)
        editableProfile.birthday = birthday
        set(starSign: birthday.starSign == .none ? "" : birthday.starSign.localizedDescription)
    }

    /// Sets the star sign of the editable profile.
    ///
    /// - Parameter starSign: User star sign to set to.
    func set(starSign: String) {
        let starSigns = StarSign.all.map {$0.localizedDescription}
        guard let index = starSigns.index(of: starSign) else {
            return
        }
        editableProfile.starSign = StarSign.all[index].rawValue
        reloadStarSign()
    }

    /// Loads industries from api.
    func loadIndustries() {
        guard industries == nil else {
            return
        }
        delegate?.loadingIndustries(loading: true)
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
        editableProfile.occupations = editableOccupations.occupations
        delegate?.occupationValidityChanged(valid: editableProfile.validOccupations)
    }
    
    /// Removes the tag at the given index path.
    ///
    /// - Parameters:
    ///   - indexPath: Index path of tag.
    ///   - type: Type of tag.
    func removeTag(indexPath: IndexPath, type: ProfileTagType) {
        switch type {
        case .offers:
            editableProfile.offers.removeSafely(at: indexPath.row)
        case .interests:
            editableProfile.interests.removeSafely(at: indexPath.row)
        case .asks:
            editableProfile.asks.removeSafely(at: indexPath.row)
        }
        loadTags()
    }
    
    /// Reloads star signs with a new star sign that's automatically generated from the selected birthday.
    func reloadStarSign() {
        let selectedSign = StarSign(rawValue: editableProfile.starSign ?? "")
        let localizedStarSigns = StarSign.all.map {$0.localizedDescription}
        if let index = StarSign.all.index(of: selectedSign ?? .none) {
            delegate?.displayStarSigns(starSigns: localizedStarSigns, selectedIndex: index)
        }
    }
        
    /// Formats a birthday string to display in the text field.
    ///
    /// - Parameters:
    ///   - month: Birthday month to use.
    ///   - day: Birthday day to use.
    /// - Returns: Formatted birthday string. (e.g. January 4)
    func formatBirthdayString(month: Int, day: Int) -> String {
        if month == 0 || day == 0 {
            return "--"
        } else {
            return Birthday(month: month, day: day).formattedBirthdayString
        }
    }

}

// MARK: - Private Functions
private extension EditProfileViewModel {
    
    func loadProfileImage() {
        delegate?.displayProfileImage(photo: editableProfile.photo)
    }
    
    func loadNames() {
        delegate?.displayHeaderInfoView(firstName: user.profile.name.first.whitespaceTrimmed,
                                        lastName: user.profile.name.last.whitespaceTrimmed,
                                        headline: editableProfile.headline ?? "")
    }

    func loadBiography() {
        delegate?.displayBiography(editableProfile.biography)
    }
    
    func loadNeighborhood() {
        delegate?.display(neighborhood: editableProfile.neighborhood)
    }
    
    func loadEmail() {
        delegate?.display(email: editableProfile.contactEmail)
    }
    
    func loadOccupations() {
        if let occupations = user.profile.occupations, !occupations.isEmpty {
            delegate?.displayOccupationItemView(occupations: occupations)
            editableOccupations.occupations = occupations
        } else {
            delegate?.displayEmptyOccupationView()
        }
    }
    
    func loadSocial() {
        delegate?.displaySocialLinksView(website: editableProfile.website,
                                         instagram: editableProfile.instagram?.extractedUserName(),
                                         facebook: editableProfile.facebook?.extractedUserName(),
                                         twitter: editableProfile.twitter?.extractedUserName())
    }

    func loadTags() {
        delegate?.displayOffersTags(tags: editableProfile.offers)
        delegate?.displayInterestTags(tags: editableProfile.interests)
        delegate?.displayLookingForTags(tags: editableProfile.asks)
    }

    func loadStarSigns() {
        let localizedStarSigns = StarSign.all.map {$0.localizedDescription}
        let starSign = StarSign(rawValue: editableProfile.starSign ?? "")
        let selectedSignIndex = StarSign.all.index(of: starSign ?? .none)
        let index = selectedSignIndex == 0 ? nil : selectedSignIndex
        delegate?.displayStarSigns(starSigns: localizedStarSigns, selectedIndex: index)
    }
    
    func loadBirthday() {
        let months = DateFormatter().monthSymbols
        let selectedMonth = editableProfile.birthday?.month
        let days = Date.days(for: selectedMonth)
        
        var monthSelected = 0
        if let month = selectedMonth, month >= 0, month <= 12 {
            monthSelected = month
        }
        
        let day = monthSelected == 0 ? 0 : editableProfile.birthday?.day ?? 0
        let selectedDate = monthSelected == 0 ? nil : Birthday(month: monthSelected, day: day)
        delegate?.displayBirthday(months: ["-"] + (months ?? []),
                                  days: ["-"] + days.map {String($0)},
                                  selectedDate: selectedDate)
    }

    func updateIndustryData(industries: [Industry]) {
        self.industries = industries
        var selectedIndex: Int?
        if let industry = editableProfile.industry {
            selectedIndex = industries.index(of: industry)
        }
        delegate?.displayIndustries(industries: industries.map { $0.name }, selectedIndex: selectedIndex)
    }
    
    func updateProfileWithAvatar(_ avatar: Data) {
        dependencyProvider.networkProvider.userLoader.upload(avatar: avatar, result: { (result) in
            if let result = result {
                self.updateAvatarUrl(result, completion: {
                    NotificationCenter.default.post(name: Notification.Name.didUploadAvatar, object: nil)
                    self.uploadProfile()
                })
            }
        }) { (error) in
            self.delegate?.displayError(error)
        }
    }
    
    func updateAvatarUrl(_ result: [String: Any], completion: () -> Void) {
        if let avatarUrl = result["response"] as? String {
            editableProfile.photo = avatarUrl
            completion()
        }
    }
    
    func uploadProfile() {
        configureHeadline()
        dependencyProvider.networkProvider.userLoader.update(profile: editableProfile) { [weak self] (result) in
            self?.delegate?.isLoading(loading: false)
            result.ifSuccess {
                self?.delegate?.dismissAction()
            }
            result.ifFailure {
                self?.delegate?.displayError(result.error)
            }
        }
    }
    
    func add(newTag: String, type: ProfileTagType) {
        switch type {
        case .offers:
            if !(editableProfile.offers.contains(newTag)) {
                editableProfile.offers.append(newTag)
            }
        case .interests:
            if !(editableProfile.interests.contains(newTag)) {
                editableProfile.interests.append(newTag)
            }
        case .asks:
            if !(editableProfile.asks.contains(newTag)) {
                editableProfile.asks.append(newTag)
            }
        }
        loadTags()
    }
    
    func configureHeadline() {
        guard let occupationString = editableOccupations.occupations.first?.formattedText() else {
            return
        }
        
        let headline = editableProfile.headline?.whitespaceTrimmedAndNilIfEmpty
        editableProfile.headline = headline == nil ? occupationString : headline
    }

}

// MARK: - EditHeaderInfoViewDelegate
extension EditProfileViewModel: EditHeaderInfoViewDelegate {
    
    func firstNameUpdated(with name: String?) {
        editableProfile.firstName = name?.whitespaceTrimmed
        delegate?.firstNameValidityChanged(valid: editableProfile.validFirstName)
    }
    
    func lastNameUpdated(with name: String?) {
        editableProfile.lastName = name?.whitespaceTrimmed
        delegate?.lastNameValidityChanged(valid: editableProfile.validLastName)
    }
    
    func headlineUpdated(with text: String?) {
        editableProfile.headline = text?.whitespaceTrimmed
    }
    
}

// MARK: - EditBiographyViewDelegate
extension EditProfileViewModel: EditBiographyViewDelegate {
    
    func biographyDidChange(_ text: String?) {
        editableProfile.biography = text?.whitespaceTrimmed
        delegate?.biographyValidityChanged(valid: editableProfile.validBiography)
    }
    
}

// MARK: - EditSocialLinksDelegate
extension EditProfileViewModel: EditSocialLinksDelegate {

    func facebookUpdated(username: String?) {
        editableProfile.facebook = String.facebookURL(with: username?.whitespaceTrimmed)
        delegate?.socialLinkValidityChanged(valid: editableProfile.validFacebook, socialType: .facebook)
    }

    func instagramUpdated(username: String?) {
        editableProfile.instagram = String.instagramURL(with: username?.whitespaceTrimmed)
        delegate?.socialLinkValidityChanged(valid: editableProfile.validInstagram, socialType: .instagram)
    }

    func twitterUpdated(username: String?) {
        editableProfile.twitter = String.twitterURL(with: username?.whitespaceTrimmed)
        delegate?.socialLinkValidityChanged(valid: editableProfile.validTwitter, socialType: .twitter)
    }

    func websiteUpdated(link: String?) {
        editableProfile.website = link?.whitespaceTrimmed
        delegate?.socialLinkValidityChanged(valid: editableProfile.validWebsite, socialType: .web)
    }

}

// MARK: - EditProfileInformationFormViewDelegate
extension EditProfileViewModel: EditProfileInformationFormViewDelegate {
    
    func neighborhoodUpdated(_ neighborhood: String?) {
        editableProfile.neighborhood = neighborhood?.whitespaceTrimmed
    }
    
    func emailUpdated(_ email: String?) {
        editableProfile.contactEmail = email?.whitespaceTrimmed
        delegate?.emailValidityChanged(valid: editableProfile.validEmail)
    }
    
}

// MARK: - SearchTagsDelegate
extension EditProfileViewModel: SearchTagsDelegate {
    
    func add(tag: String, type: ProfileTagType) {
        add(newTag: tag, type: type)
    }
    
}
