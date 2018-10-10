//
//  OnboardingPhotoEditorViewController.swift
//  TheWing
//
//  Created by Luna An on 7/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingPhotoEditorViewController: OnboardingBaseEditorViewController {

    // MARK: - Public Properties

    /// Binding delegate for the view model.
    var viewModel: OnboardingPhotoEditorViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override var analyticsProperties: [String: Any] {
        return viewModel.analyticsProperties
    }
    
    override var progressStep: OnboardingProgressStep? {
        return .photo
    }
    
    // MARK: - Private Properties
    
    private lazy var buttonsView: OnboardingButtonsView = {
        let buttonsView = OnboardingButtonsView(theme: theme, delegate: self)
        buttonsView.hideBackButton()
        return buttonsView
    }()
    
    private lazy var titleLabel: UILabel = {
        let textStyle = theme.textStyleTheme.headline1.withColor(theme.colorTheme.primary).withEmFont()
        return UILabel(text: OnboardingLocalization.photoScreenTitle, using: textStyle)
    }()
        
    private lazy var fancyFrameView: FancyFrameView = {
        let imageView = FancyFrameView(theme: theme)
        imageView.accessibilityTraits = UIAccessibilityTraitButton
        imageView.accessibilityHint = OnboardingLocalization.profilePhotoAccessibilityHint
        imageView.delegate = self
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(presentPhotoLibraryPermissionsAlert)))
        imageView.image = #imageLiteral(resourceName: "add_photo_icon")
        imageView.autoSetDimensions(to: CGSize(width: 216, height: 150))
        imageView.cornerRadius = 75
        imageView.isHidden = false
        return imageView
    }()
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.loadProfileImage()
        delegate?.editorViewController(viewController: self, updateStage: .basics(.inProgress))
    }

}

// MARK: - Private Functions
private extension OnboardingPhotoEditorViewController {
    
    func setupView() {
        delegate?.editorViewController(viewController: self,
                                       setProgressViewIsHidden: false,
                                       collapse: false,
                                       animated: true,
                                       completion: nil)
        view.backgroundColor = theme.colorTheme.invertTertiary
        setupButtonsView()
        setupTitle()
        setupImageView()
    }
    
    private func setupButtonsView() {
        view.addSubview(buttonsView)
        buttonsView.autoPinEdgesToSuperviewEdges(excludingEdge: .bottom)
        if let image = fancyFrameView.image, !image.isEqualToImage(image: #imageLiteral(resourceName: "add_photo_icon")) {
            buttonsView.showNextButton(show: true)
        }
    }
    
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.autoPinEdge(.top, to: .bottom, of: buttonsView)
        titleLabel.autoPinEdge(.leading, to: .leading, of: view, withOffset: ViewConstants.defaultGutter)
        titleLabel.autoPinEdge(.trailing, to: .trailing, of: view, withOffset: -ViewConstants.defaultGutter)
    }
    
    private func setupImageView() {
        view.addSubview(fancyFrameView)
        fancyFrameView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 48)
        fancyFrameView.autoAlignAxis(.vertical, toSameAxisOf: titleLabel)
    }
    
}

// MARK: - OnboardingPhotoEditorViewDelegate
extension OnboardingPhotoEditorViewController: OnboardingPhotoEditorViewDelegate {
    
    func setPlaceholderImage() {
        fancyFrameView.setImage(with: #imageLiteral(resourceName: "add_photo_icon"))
    }

    func displayPhoto(from photoURL: URL) {
        fancyFrameView.setImage(url: photoURL)
    }
    
    func loadingPhoto(loading: Bool) {
        fancyFrameView.isLoading = loading
    }
    
    func showNextButton(show: Bool) {
        buttonsView.showNextButton(show: show)
    }
    
    func isLoading(_ loading: Bool) {
        buttonsView.isLoading(loading)
    }
    
    func imageValidated() {
        goToNextStep()
        viewModel.resetAnalyticsProperties()
    }
    
    func displayError(error: Error?) {
        presentAlertController(withNetworkError: error)
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
            fancyFrameView.setImage(with: selectedImage) {
                if let imageData = selectedImage.imageData {
                    self.viewModel.set(newImageData: imageData)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}

// MARK: - OnboardingButtonsViewDelegate
extension OnboardingPhotoEditorViewController: OnboardingButtonsViewDelegate {
    
    func backButtonSelected() {
        goToPreviousStep()
    }
    
    func nextButtonSelected() {
        viewModel.updateProfile()
    }
    
}

// MARK: - FancyFrameViewDelegate
extension OnboardingPhotoEditorViewController: FancyFrameViewDelegate {
    
    func imageLoaded(_ loaded: Bool) {
        showNextButton(show: loaded)
    }
    
}
