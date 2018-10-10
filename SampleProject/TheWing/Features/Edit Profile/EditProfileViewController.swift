//
//  EditProfileViewController.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Pilas

final class EditProfileViewController: BuildableViewController {
    
    // MARK: - Public Properties
    
    /// View model.
    var viewModel: EditProfileViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    weak var delegate: EditProfileDelegate?
    
    // MARK: - Private Properties
    
    private lazy var subviewContainer: EditProfileSubviewCollection = {
        let container = EditProfileSubviewCollection(theme: theme, editProfileViewController: self)
        container.neighborhoodView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                               action: #selector(neighborhoodViewSelected)))
        return container
    }()
    
    private lazy var editPhotoView: EditProfilePhotoView = {
        let editPhotoView = EditProfilePhotoView(theme: theme)
        editPhotoView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentPhotoLibraryPermissionsAlert))
        editPhotoView.addGestureRecognizer(tap)
        return editPhotoView
    }()
    
    private lazy var saveButton: StylizedButton = {
        let button = StylizedButton(buttonStyle: theme.buttonStyleTheme.primaryFloatingButtonStyle)
        button.setTitle("SAVE".localized(comment: "Save").uppercased(), for: .normal)
        button.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.isiPhoneXOrBigger ? 10 : 0, right: 0)
        button.isEnabled = true
        return button
    }()
    
    private lazy var saveButtonContainer: UIView = {
        let containerView = UIView()
        containerView.addSubview(saveButton)
        saveButton.autoPinEdgesToSuperviewEdges()
        return containerView
    }()
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.colorTheme.invertTertiaryFaded
        return view
    }()
    
    private var formFields: [FormField] {
        var fields: [FormField] = [subviewContainer.headerView,
                                   subviewContainer.biographyView,
                                   subviewContainer.socialView,
                                   subviewContainer.emailView]
        fields.setForm(delegate: self)
        return fields
    }
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        addRecognizerForKeyboardDismissal()
        viewModel.loadUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.layer.shadowOpacity = subviewContainer.scrollView.navigationShadowOpacity
        navigationController?.navigationBar.isHidden = false
        
        subviewContainer.scrollTo(entrySelection: viewModel.entrySelection)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideAllPickerViews()
        navigationController?.navigationBar.layer.shadowOpacity = 0.0
        view.endEditing(true)
    }
    
}

// MARK: - Private Functions
private extension EditProfileViewController {
    
    func setupDesign() {
        view.backgroundColor = theme.colorTheme.invertTertiary
        setupNavigationBar()
        setupScrollView()
        setupSaveButton()
    }
    
    func setupScrollView() {
        subviewContainer.scrollView.enableKeyboardNotifications = true
        subviewContainer.scrollView.insertView(view: editPhotoView)
        subviewContainer.scrollView.insertView(view: subviewContainer.headerView)
        subviewContainer.scrollView.insertView(view: subviewContainer.biographyView)
        subviewContainer.scrollView.insertView(view: subviewContainer.occupationView)
        subviewContainer.scrollView.insertView(view: subviewContainer.emptyOccupationView)
        subviewContainer.scrollView.insertView(view: subviewContainer.industryPicker.fieldView)
        subviewContainer.scrollView.insertDividerView(height: 24)
        subviewContainer.scrollView.insertView(view: subviewContainer.socialView)
        subviewContainer.scrollView.insertDividerView(height: 24)
        subviewContainer.scrollView.insertView(view: subviewContainer.offersSectionView)
        subviewContainer.scrollView.insertView(view: subviewContainer.asksSectionView)
        subviewContainer.scrollView.insertView(view: subviewContainer.interestedInSectionView)
        subviewContainer.scrollView.insertDividerView(height: 32)
        subviewContainer.scrollView.insertView(view: subviewContainer.neighborhoodView)
        subviewContainer.scrollView.insertView(view: subviewContainer.birthdayPicker.fieldView)
        subviewContainer.scrollView.insertView(view: subviewContainer.starSignPicker.fieldView)
        subviewContainer.scrollView.insertView(view: subviewContainer.emailView)
        subviewContainer.scrollView.insertDividerView(height: 24)
    }
    
    func setupSaveButton() {
        view.addSubview(saveButtonContainer)
        saveButtonContainer.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        saveButton.set(height: ViewConstants.bottomButtonHeight)
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: saveButton.frame.height, right: 0)
        subviewContainer.scrollView.contentInset = insets
        subviewContainer.scrollView.defaultBottomInset = insets.bottom
    }
    
    func setupNavigationBar() {
        navigationController?.setNavigationBar(backgroundColor: theme.colorTheme.invertTertiary,
                                               tintColor: theme.colorTheme.emphasisPrimary,
                                               textStyle: theme.textStyleTheme.headline3)
        navigationController?.removeNavigationBarBorder()
        navigationController?.addDropShadow(color: theme.colorTheme.emphasisQuintary,
                                            offset: ViewConstants.navigationBarShadowOffset,
                                            radius: ViewConstants.navigationBarShadowRadius)
        navigationController?.navigationBar.clipsToBounds = false
        navigationItem.title = "EDIT_PROFILE_TITLE".localized(comment: "Edit profile title")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close_button"),
                                                           style: .plain,
                                                           target: viewModel,
                                                           action: #selector(viewModel.discardAttempt))
    }
    
    func showOccupations(visible: Bool) {
        subviewContainer.occupationView.isHidden = !visible
        subviewContainer.emptyOccupationView.isHidden = visible
    }
    
    func showLoadingView(loading: Bool) {
        if loading {
            loadingView.alpha = 0
            view.insertSubview(loadingView, belowSubview: saveButton)
            loadingView.autoPinEdgesToSuperviewEdges()
            
            UIView.animate(withDuration: AnimationConstants.fastAnimationDuration, animations: {
                self.loadingView.alpha = 1
            })
        } else {
            loadingView.alpha = 1
            view.insertSubview(loadingView, belowSubview: saveButton)
            UIView.animate(withDuration: AnimationConstants.fastAnimationDuration, animations: {
                self.loadingView.alpha = 0
            }, completion: { (_) in
                self.loadingView.removeFromSuperview()
            })
        }
    }
    
    func hideAllPickerViews() {
        subviewContainer.industryPicker.hidePickerView()
        subviewContainer.birthdayPicker.hidePickerView()
        subviewContainer.starSignPicker.hidePickerView()
    }
    
    func textFieldPickerItemSelected(item: String, textFieldPicker: TextFieldPicker) {
        switch textFieldPicker.fieldView {
        case subviewContainer.industryPicker.fieldView:
            viewModel.set(industry: item)
        case subviewContainer.starSignPicker.fieldView:
            viewModel.set(starSign: item)
        default:
            fatalError("Unknown TextFieldPicker instance")
        }
    }
    
    func textFieldPickerItemsSelected(firstItem: Int, secondItem: Int, textFieldPicker: TextFieldPicker) {
        switch textFieldPicker.fieldView {
        case subviewContainer.birthdayPicker.fieldView:
            viewModel.set(birthdayMonth: firstItem, birthdayDay: secondItem)
        default:
            fatalError("Unknown TextFieldPicker instance")
        }
    }
    
    func textFieldPickerSelected(textFieldPicker: TextFieldPicker) {
        switch textFieldPicker.fieldView {
        case subviewContainer.industryPicker.fieldView:
            viewModel.loadIndustries()
            subviewContainer.starSignPicker.hidePickerView()
            subviewContainer.birthdayPicker.hidePickerView()
        case subviewContainer.birthdayPicker.fieldView:
            subviewContainer.industryPicker.hidePickerView()
            subviewContainer.starSignPicker.hidePickerView()
        case subviewContainer.starSignPicker.fieldView:
            subviewContainer.industryPicker.hidePickerView()
            subviewContainer.birthdayPicker.hidePickerView()
        default:
            fatalError("Unknown TextFieldPicker instance")
        }
    }
    
    @objc func neighborhoodViewSelected() {
        let searchViewController = builder.neighborhoodSearchViewController(delegate: self)
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @objc func updateProfile() {
        viewModel.updateProfile()
        analyticsProvider.track(event: AnalyticsEvents.Profile.profileSaved.analyticsIdentifier,
                                properties: currentUser?.analyticsProperties(forScreen: self),
                                options: nil)
    }

}

// MARK: - NeighborhoodSearchViewControllerDelegate
extension EditProfileViewController: NeighborhoodSearchViewControllerDelegate {
    
    func neighborhoodSearchViewController(_ viewController: NeighborhoodSearchViewController,
                                          didSelectNeighborhood neighborhood: String) {
        subviewContainer.neighborhoodView.setInformation(neighborhood)
        viewModel.neighborhoodUpdated(neighborhood)
        navigationController?.popViewController(animated: true)
    }
    
    func neighborhoodSearchViewControllerCancelTouchUpInside(_ viewController: NeighborhoodSearchViewController) {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UIScrollViewDelegate
extension EditProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationController?.navigationBar.layer.shadowOpacity = scrollView.navigationShadowOpacity
    }
    
}

// MARK: - EditProfileViewDelegate
extension EditProfileViewController: EditProfileViewDelegate {
    
    func saveEnabledChanged(enabled: Bool) {
        saveButton.isEnabled = enabled
    }
    
    func displayProfileImage(photo: String?) {
        editPhotoView.setImage(with: photo)
    }
    
    func displayHeaderInfoView(firstName: String, lastName: String, headline: String) {
        subviewContainer.headerView.setHeaderFields(firstName: firstName, lastName: lastName, headline: headline)
    }
    
    func displayBiography(_ biography: String?) {
        subviewContainer.biographyView.set(biography)
    }
    
    func displaySocialLinksView(website: String?, instagram: String?, facebook: String?, twitter: String?) {
        subviewContainer.socialView.set(web: website, instagram: instagram, facebook: facebook, twitter: twitter)
    }
    
    func displayOccupationItemView(occupations: [Occupation]) {
        showOccupations(visible: true)
        subviewContainer.occupationView.occupations = occupations
    }
    
    func displayEmptyOccupationView() {
        showOccupations(visible: false)
    }
    
    func displayIndustries(industries: [String], selectedIndex: Int?) {
        subviewContainer.industryPicker.display(items: industries, selectedIndex: selectedIndex)
    }
    
    func displayInterestTags(tags: [String]?) {
        subviewContainer.interestedInSectionView.setup(tags: tags)
    }
    
    func displayOffersTags(tags: [String]?) {
        subviewContainer.offersSectionView.setup(tags: tags)
    }
    
    func displayLookingForTags(tags: [String]?) {
        subviewContainer.asksSectionView.setup(tags: tags)
    }
    
    func displayBirthday(months: [String], days: [String], selectedDate: Birthday?) {
        subviewContainer.birthdayPicker.display(months: months, days: days, selectedDate: selectedDate)
    }
    
    func displayStarSigns(starSigns: [String], selectedIndex: Int?) {
        subviewContainer.starSignPicker.display(items: starSigns, selectedIndex: selectedIndex)
    }
    
    func display(neighborhood: String?) {
        subviewContainer.neighborhoodView.setInformation(neighborhood)
    }
    
    func display(email: String?) {
        subviewContainer.emailView.setInformation(email)
    }
    
    func presentDiscardAlert() {
        let discardTitle = "DISCARD_CONFIRMATION".localized(comment: "Discard Changes?")
        let discardAction = "ALERT_DISCARD_TITLE".localized(comment: "Discard")
        let discardMessage = "DISCARD_MESSAGE".localized(comment: "Are you sure you want to discard your changes?")
        let alert = UIAlertController.deleteActionAlertController(title: discardTitle,
                                                                  message: discardMessage,
                                                                  deleteTitle: discardAction) { (_) in
                                                                    self.confirmDismissal()
        }
        present(alert, animated: true, completion: nil)
    }
    
    func confirmDismissal() {
        analyticsProvider.track(event: AnalyticsEvents.Profile.editModeDismissed.analyticsIdentifier,
                                properties: currentUser?.analyticsProperties(forScreen: self),
                                options: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func dismissAction() {
        delegate?.editProfileCompleted()
        dismiss(animated: true, completion: nil)
    }
    
    func isLoading(loading: Bool) {
        saveButton.isLoading(loading: loading)
        showLoadingView(loading: loading)
    }
    
    func loadingIndustries(loading: Bool) {
        subviewContainer.industryPicker.pickerView?.isLoading = loading
    }
    
    func setOccupation(occupation: Occupation?, originalOccupation: Occupation?, deleted: Bool) {
        viewModel.updateOccupations(occupation: occupation,
                                    originalOccupation: originalOccupation,
                                     deleted: deleted)
    }
    
}

// MARK: - EditOccupationDelegate, EditEmptyOccupationDelegate
extension EditProfileViewController: EditOccupationDelegate, EditEmptyOccupationDelegate {
    
    func editOccupationSelected(occupation: Occupation) {
        let viewController = builder.editOccupationViewController(delegate: self, occupation: occupation)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func addOccupationSelected() {
        let viewController = builder.addOccupationViewController(delegate: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - EditProfilePhotoViewDelegate
extension EditProfileViewController: EditProfilePhotoViewDelegate {
    
    func editPhoto() {
        presentPhotoLibraryPermissionsAlert()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            editPhotoView.setImage(with: selectedImage) {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setNewAvatar(newAvatar: UIImage) {
        if !newAvatar.isEqualToImage(image: #imageLiteral(resourceName: "avatar")), let imageData = newAvatar.imageData {
            viewModel.set(newImageData: imageData)
        }
    }
    
}

// MARK: - EditProfileViewValidationDelegate
extension EditProfileViewController: EditProfileViewValidationDelegate {
    
    func socialLinkValidityChanged(valid: Bool, socialType: SocialType) {
        guard !valid else {
            subviewContainer.socialView.hideError(in: socialType)
            return
        }
        
        subviewContainer.socialView.showError(in: socialType, errorMessage: socialType.localizedError)
    }
  
    func firstNameValidityChanged(valid: Bool) {
        let localizedError = "FIRST_NAME_ERROR".localized(comment: "First name error")
        let headerView = subviewContainer.headerView
        valid ? headerView.firstNameTextField.hideError() : headerView.firstNameTextField.showError(localizedError)
    }
    
    func lastNameValidityChanged(valid: Bool) {
        let localizedError = "LAST_NAME_ERROR".localized(comment: "Last name error")
        let headerView = subviewContainer.headerView
        valid ? headerView.lastNameTextField.hideError() : headerView.lastNameTextField.showError(localizedError)
    }
    
    func biographyValidityChanged(valid: Bool) {
        subviewContainer.biographyView.setShowError(!valid)
    }
    
    func emailValidityChanged(valid: Bool) {
        let localizedError = "EMAIL_ERROR_MESSAGE".localized(comment: "Email error")
        valid ? subviewContainer.emailView.hideError() : subviewContainer.emailView.showError(localizedError)
    }
    
    func occupationValidityChanged(valid: Bool) {
        let localizedError = "EDIT_PROFILE_OCCUPATION_ERROR_MESSAGE".localized(comment: "Occupation error")
        if valid {
            subviewContainer.emptyOccupationView.hideError()
        } else {
            subviewContainer.emptyOccupationView.showError(localizedError)
        }
    }

}

// MARK: - TextFieldPickerDelegate
extension EditProfileViewController: TextFieldPickerDelegate {
    
    func didSelectField(textFieldPicker: TextFieldPicker) {
        textFieldPickerSelected(textFieldPicker: textFieldPicker)
        formFields.resignCurrentResponder()
        let pickerViewHeight = textFieldPicker.pickerView?.frame.height ?? textFieldPicker.datePickerView?.frame.height
        subviewContainer.scrollView.contentInset.bottom = pickerViewHeight ?? 0
        subviewContainer.scrollView.scrollRectToVisible(textFieldPicker.fieldView.frame, animated: true)
    }
    
    func didSelectPickerItem(item: String, textFieldPicker: TextFieldPicker) {
        textFieldPicker.fieldView.set(text: item)
        textFieldPickerItemSelected(item: item, textFieldPicker: textFieldPicker)
    }
    
    func didSelectPickerItems(firstItem: Int, secondItem: Int, textFieldPicker: TextFieldPicker) {
        textFieldPickerItemsSelected(firstItem: firstItem, secondItem: secondItem, textFieldPicker: textFieldPicker)
        textFieldPicker.fieldView.set(text: viewModel.formatBirthdayString(month: firstItem, day: secondItem))
    }
    
    func didSelectDone(textFieldPicker: TextFieldPicker) {
        subviewContainer.scrollView.contentInset.bottom = subviewContainer.scrollView.defaultBottomInset
    }
    
}

// MARK: - FormDelegate
extension EditProfileViewController: FormDelegate {
    
    func didEnterField() {
        hideAllPickerViews()
    }
    
}

// MARK: - EditTagsSectionViewDelegate
extension EditProfileViewController: EditTagsSectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case subviewContainer.offersSectionView.collectionView:
            viewModel.removeTag(indexPath: indexPath, type: .offers((isSelectable: false, isRemovable: false)))
        case subviewContainer.interestedInSectionView.collectionView:
            viewModel.removeTag(indexPath: indexPath, type: .interests((isSelectable: false, isRemovable: false)))
        case subviewContainer.asksSectionView.collectionView:
            viewModel.removeTag(indexPath: indexPath, type: .asks((isSelectable: false, isRemovable: false)))
        default:
            return
        }
    }
    
    func addNewTags(type: ProfileTagType) {
        let viewController = builder.searchTagsViewController(type: type, searchDelegate: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - AnalyticsIdentifiable
extension EditProfileViewController: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.editProfile.analyticsIdentifier
    }

}
