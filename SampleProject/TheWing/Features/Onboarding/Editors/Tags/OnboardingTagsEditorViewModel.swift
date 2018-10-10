//
//  OnboardingTagsEditorViewModel.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/25/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

final class OnboardingTagsEditorViewModel {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: OnboardingTagsEditorViewDelegate?
    
    /// Title of collection.
    var title: String {
        switch type {
        case .asks:
            return OnboardingLocalization.asksTitle
        case .offers:
            return OnboardingLocalization.offersTitle
        case .interests:
            return OnboardingLocalization.interestsTitle
        }
    }
    
    /// Description of collection.
    var description: String {
        switch type {
        case .asks:
            return OnboardingLocalization.asksDescription
        case .offers:
            return OnboardingLocalization.offersDescription
        case .interests:
            return OnboardingLocalization.interestsDescription
        }
    }
    
    /// Placeholder text for search bar.
    var searchTitle: String {
        switch type {
        case .asks:
            return OnboardingLocalization.searchAsks
        case .offers:
            return OnboardingLocalization.searchOffers
        case .interests:
            return OnboardingLocalization.searchInterests
        }
    }
    
    /// Progess step to update top progress bar with
    var progressStep: OnboardingProgressStep {
        switch type {
        case .asks:
            return .asks
        case .offers:
            return .offers
        case .interests:
            return .interests
        }
    }
    
    /// Profile tag type
    let type: OnboardingProfileTagType
    
    /// All tags to display.
    var tags: [String] = [] {
        didSet {
            delegate?.refreshCollection()
        }
    }
    
    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider
    
    private var selectedTags: [Int] = [] {
        didSet {
            delegate?.refreshCollection()
        }
    }
    
    private static let pageSize = 12
    
    private var initialSelectedTagIndices = Set<Int>()
    
    private var finalSelectedTagIndices: Set<Int> {
        return Set<Int>(selectedTags)
    }
    
    private var updateState: OnboardingAnalyticsUpdate {
        return OnboardingAnalyticsUpdate.with(initialSelectedTagIndeces: initialSelectedTagIndices,
                                              finalSelectedTagIndeces: finalSelectedTagIndices)
    }
    
    private var previouslyCompleted: Bool {
        return !initialSelectedTagIndices.isEmpty
    }
    
    // MARK: - Initialization
    
    init(type: OnboardingProfileTagType, dependencyProvider: DependencyProvider) {
        self.type = type
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions
    
    /// Loads examples of tags from network.
    func loadExampleTags() {
        loadSavedTags()
        let loader = dependencyProvider.networkProvider.searchResultsLoader
        switch type {
        case .asks:
            loader.searchAsks(pageSize: OnboardingTagsEditorViewModel.pageSize,
                              page: 1,
                              query: "") { [weak self] (result) in
                                self?.handleTagsResponse(success: result.isSuccess, list: result.value?.data.asks)
            }
        case .offers:
            loader.searchOffers(pageSize: OnboardingTagsEditorViewModel.pageSize,
                                page: 1,
                                query: "") { [weak self] (result) in
                                    self?.handleTagsResponse(success: result.isSuccess, list: result.value?.data.offers)
            }
        case .interests:
            loader.searchInterests(pageSize: OnboardingTagsEditorViewModel.pageSize,
                                   page: 1,
                                   query: "") { [weak self] (result) in
                                    self?.handleTagsResponse(success: result.isSuccess, list: result.value?.data.interests)
            }
        }
    }
    
    /// Event handler for when an attempt is made to proceed to the next step.
    func next() {
        guard tagsWereEdited() else {
            delegate?.proceed()
            return
        }
        
        delegate?.isLoading(true)
        let fields = [type.parameterKey: selectedTags.map { tags[$0] }]
        dependencyProvider.networkProvider.userLoader.updateProfile(fields: fields) { [weak self] (result) in
            self?.delegate?.isLoading(false)
            result.ifSuccess {
                self?.delegate?.proceed()
            }
            result.ifFailure {
                self?.configureError(result.error)
            }
        }
    }
    
    /// Determines if tag at given index is in the selected state.
    ///
    /// - Parameter index: Index of tag.
    /// - Returns: True, if in selected state, false otherwise.
    func isSelected(at index: Int) -> Bool {
        guard index < tags.count else {
            return false
        }
        
        return selectedTags.contains(index)
    }
    
    /// Event handler for when a tag was toggled.
    ///
    /// - Parameter index: Index at which tag was toggled.
    func didSelectTag(at index: Int) {
        guard index < tags.count else {
            return
        }
        
        if let selectedIndex = selectedTags.index(of: index) {
            selectedTags.remove(at: selectedIndex)
        } else {
            selectedTags.append(index)
        }
    }
    
    /// Reset these ready for use when the view subsequently gets shown again.
    func resetAnalyticsProperties() {
        initialSelectedTagIndices = finalSelectedTagIndices
    }
    
}

// MARK: - Private Functions
private extension OnboardingTagsEditorViewModel {
    
    var editedProfile: EditableProfile? {
        guard let user = dependencyProvider.networkProvider.sessionManager.user else {
            return nil
        }
        
        var editableProfile = EditableProfile(user: user)
        let selections = selectedTags.map { tags[$0] }
        switch type {
        case .asks:
            if selections != editableProfile.asks {
                editableProfile.asks = selections
                return editableProfile
            }
        case .offers:
            if selections != editableProfile.offers {
                editableProfile.offers = selections
                return editableProfile
            }
        case .interests:
            if selections != editableProfile.interests {
                editableProfile.interests = selections
                return editableProfile
            }
        }
        
        return nil
    }
    
    func handleTagsResponse(success: Bool, list: [SearchResult]?) {
        if success {
            if let results = list, !results.isEmpty {
                tags += results.map { $0.name }.filter { !tags.contains($0) }
            }
        } else {
            loadDefaultTags()
        }
    }
    
    func loadSavedTags() {
        guard let user = dependencyProvider.networkProvider.sessionManager.user else {
            return
        }
        let profile = EditableProfile(user: user)
        switch type {
        case .asks:
            tags = profile.asks
        case .offers:
            tags = profile.offers
        case .interests:
            tags = profile.interests
        }
        selectedTags = tags.isEmpty ? [] : Array(0..<tags.count)
        initialSelectedTagIndices = Set<Int>(selectedTags)
    }
    
    func loadDefaultTags() {
        tags += type.defaults.filter { !tags.contains($0) }
    }

    func tagsWereEdited() -> Bool {
        guard let user = dependencyProvider.networkProvider.sessionManager.user else {
            return false
        }
        
        let selections = selectedTags.map { tags[$0] }
        switch type {
        case .asks:
            return selections != user.profile.asks
        case .offers:
            return selections != user.profile.offers
        case .interests:
            return selections != user.profile.interests
        }
    }

    func configureError(_ error: Error?) {
        guard let error = error else {
            delegate?.showError(APIError.noDataRetreived)
            return
        }
        
        delegate?.showError(error)
    }
    
}

// MARK: - SearchTagsDelegate
extension OnboardingTagsEditorViewModel: SearchTagsDelegate {
    
    func add(tag: String, type: ProfileTagType) {
        if let index = tags.index(of: tag), selectedTags.contains(index) {
            return
        }
        
        let selections = selectedTags.map { tags[$0] } + [tag]
        selectedTags = []
        
        if let index = tags.index(of: tag), !selectedTags.contains(index) {
            tags.remove(at: index)
        }
        
        tags.insert(tag, at: 0)
        selectedTags = selections.compactMap { tags.index(of: $0) }
    }
    
}

// MARK: - AnalyticsIdentifiable
extension OnboardingTagsEditorViewModel: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return progressStep.analyticsIdentifier
    }
    
    var analyticsProperties: [String: Any] {
        return [
            AnalyticsEvents.Onboarding.stepName: analyticsIdentifier,
            AnalyticsEvents.Onboarding.stepPreviouslyCompleted: previouslyCompleted,
            AnalyticsEvents.Onboarding.stepUpdated: updateState.analyticsIdentifier
        ]
    }
    
}
