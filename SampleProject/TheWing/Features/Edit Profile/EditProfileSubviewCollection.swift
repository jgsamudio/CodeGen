//
//  EditProfileSubviewCollection.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import Pilas

/// Collection of subviews used to remove setup view code from the view controller.
final class EditProfileSubviewCollection {

    // MARK: - Private Properties

    private let theme: Theme

    private weak var editProfileViewController: EditProfileViewController?

    // MARK: - Initialization

    init(theme: Theme, editProfileViewController: EditProfileViewController?) {
        self.theme = theme
        self.editProfileViewController = editProfileViewController
    }

    // MARK: - Public Properties

    lazy var scrollView: PilasScrollView = {
        let scrollView = PilasScrollView()
        editProfileViewController?.view.addSubview(scrollView)
        scrollView.delegate = editProfileViewController
        scrollView.autoPinEdgesToSuperviewEdges()
        return scrollView
    }()

    lazy var headerView: EditHeaderInfoView = {
        let view = EditHeaderInfoView(theme: theme)
        view.delegate = editProfileViewController?.viewModel
        return view
    }()

    lazy var biographyView: EditBiographyView = {
        let view = EditBiographyView(theme: theme)
        view.delegate = editProfileViewController?.viewModel
        return view
    }()

    lazy var occupationView: EditOccupationView = {
        let view = EditOccupationView(theme: theme)
        view.delegate = editProfileViewController
        view.isHidden = true
        return view
    }()

    lazy var emptyOccupationView: EditEmptyOccupationView = {
        let view = EditEmptyOccupationView(theme: theme)
        view.delegate = editProfileViewController
        view.isHidden = true
        return view
    }()

    lazy var industryPicker: TextFieldPicker = {
        let placeholder = "ADD_YOUR_INDUSTRY".localized(comment: "Add your industry")
        let floatingTitle = "INDUSTRY_REQUIRED".localized(comment: "Industry")
        return editProfilePickerBuilder.buildIndustryPicker(delegate: editProfileViewController,
                                                            placeholder: placeholder,
                                                            floatingTitle: floatingTitle)
    }()
    
    lazy var birthdayPicker: TextFieldPicker = {
        return editProfilePickerBuilder.buildBirthdayPicker(delegate: editProfileViewController)
    }()

    lazy var starSignPicker: TextFieldPicker = {
        return editProfilePickerBuilder.buildStarSignPicker(delegate: editProfileViewController)
    }()

    lazy var editProfilePickerBuilder: EditProfilePickerBuilder = {
        return EditProfilePickerBuilder(theme: theme, superView: editProfileViewController?.view)
    }()

    lazy var socialView: EditSocialLinksView = {
        let socialView = EditSocialLinksView(theme: theme)
        socialView.delegate = editProfileViewController?.viewModel
        return socialView
    }()

    lazy var neighborhoodView: EditProfileInformationFormView = {
        let placeholder = "ADD_NEIGHBORHOOD".localized(comment: "Add Your Neighborhood")
        let title = "NEIGHBORHOOD".localized(comment: "Neighborhood")
        let view = EditProfileInformationFormView(placeHolder: placeholder, title: title, type: .neighborhood, theme: theme)
        view.autocapitalizationType = .words
        view.delegate = editProfileViewController?.viewModel
        view.disableTextField()
        return view
    }()
    
    lazy var emailView: EditProfileInformationFormView = {
        let placeholder = "ADD_EMAIL".localized(comment: "Add Your Email")
        let title = "EMAIL_TITLE".localized(comment: "Email")
        let view = EditProfileInformationFormView(placeHolder: placeholder, title: title, type: .email, theme: theme)
        view.keyboardType = .emailAddress
        view.autocapitalizationType = .none
        view.delegate = editProfileViewController?.viewModel
        return view
    }()

    lazy var offersSectionView: EditTagsSectionView = {
        let type = ProfileTagType.offers(TagData(isSelectable: false, isRemovable: true))
        let view = EditTagsSectionView(theme: theme, type: type)
        view.delegate = editProfileViewController
        view.addTagText = "ADD_OFFER".localized(comment: "Add offer")
        return view
    }()

    lazy var asksSectionView: EditTagsSectionView = {
        let type = ProfileTagType.asks(TagData(isSelectable: false, isRemovable: true))
        let view = EditTagsSectionView(theme: theme, type: type)
        view.delegate = editProfileViewController
        view.addTagText = "ADD_ASKS".localized(comment: "Add Asks")
        return view
    }()

    lazy var interestedInSectionView: EditTagsSectionView = {
        let type = ProfileTagType.interests(TagData(isSelectable: false, isRemovable: true))
        let view = EditTagsSectionView(theme: theme, type: type)
        view.delegate = editProfileViewController
        view.addTagText = "ADD_INTERESTS".localized(comment: "Add Interests")
        return view
    }()

    // MARK: - Public Functions

    /// Scrolls the scrollview to the entry selection.
    ///
    /// - Parameter entrySelection: Current entry selection.
    func scrollTo(entrySelection: EmptyStateViewType?) {
        guard let entrySelection = entrySelection else {
            return
        }
        editProfileViewController?.view.layoutIfNeeded()

        switch entrySelection {
        case .bio:
            scrollView.scrollToCentered(biographyView.frame, animated: true)
        case .industry:
            scrollView.scrollToCentered(industryPicker.fieldView.frame, animated: true)
        case .offers:
            scrollView.scrollToCentered(offersSectionView.frame, animated: true)
        case .asks:
            scrollView.scrollToCentered(asksSectionView.frame, animated: true)
        case .interests:
            scrollView.scrollToCentered(interestedInSectionView.frame, animated: true)
        case .neighborhood:
            scrollView.scrollToCentered(neighborhoodView.frame, animated: true)
        case .birthday:
            scrollView.scrollToCentered(birthdayPicker.fieldView.frame, animated: true)
        case .starSign:
            scrollView.scrollToCentered(starSignPicker.fieldView.frame, animated: true)
        case .email:
            scrollView.scrollToCentered(emailView.frame, animated: true)
        }
    }

}
