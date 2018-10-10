//
//  OnboardingNeighborhoodEditorViewController.swift
//  TheWing
//
//  Created by Luna An on 7/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingNeighborhoodEditorViewController: OnboardingBaseEditorViewController {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    var viewModel: OnboardingNeighborhoodEditorViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    /// Progress step.
    override var progressStep: OnboardingProgressStep? {
        return .neighborhood
    }
    
    override var analyticsProperties: [String: Any] {
        return viewModel.analyticsProperties
    }
    
    // MARK: - Private Properties
    
    private lazy var buttonsView = OnboardingButtonsView(theme: theme, delegate: self)
    
    private lazy var titleLabel: UILabel = {
        let textStyle = theme.textStyleTheme.headline1.withColor(theme.colorTheme.primary).withEmFont()
        return UILabel(text: OnboardingLocalization.neighborhoodScreenTitle, using: textStyle)
    }()
    
    private lazy var neighborhoodView: EditProfileInformationFormView = {
        let placeholder = "ADD_NEIGHBORHOOD".localized(comment: "Add Your Neighborhood")
        let title = "NEIGHBORHOOD".localized(comment: "Neighborhood")
        let view = EditProfileInformationFormView(placeHolder: placeholder, title: title, type: .neighborhood, theme: theme)
        view.disableTextField()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(neighborhoodViewSelected)))
        view.autocapitalizationType = .words
        return view
    }()
 
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        delegate?.editorViewController(viewController: self, updateStage: .aboutYou(.inProgress))
        viewModel.loadNeighborhood()
    }
    
}

// MARK: - Private Functions
private extension OnboardingNeighborhoodEditorViewController {
    
    func setupView() {
        delegate?.editorViewController(viewController: self,
                                       setProgressViewIsHidden: false,
                                       collapse: false,
                                       animated: true,
                                       completion: nil)
        view.backgroundColor = theme.colorTheme.invertTertiary
        setupButtonsView()
        setupTitle()
        setupNeighborhoodView()
    }
    
    private func setupButtonsView() {
        view.addSubview(buttonsView)
        buttonsView.autoPinEdgesToSuperviewEdges(excludingEdge: .bottom)
        buttonsView.showNextButton(show: true)
    }
    
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.autoPinEdge(.top, to: .bottom, of: buttonsView)
        titleLabel.autoPinEdge(.leading, to: .leading, of: view, withOffset: ViewConstants.defaultGutter)
        titleLabel.autoPinEdge(.trailing, to: .trailing, of: view, withOffset: -ViewConstants.defaultGutter)
    }
    
    private func setupNeighborhoodView() {
        view.addSubview(neighborhoodView)
        neighborhoodView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 48)
        neighborhoodView.autoPinEdge(.leading, to: .leading, of: view)
        neighborhoodView.autoPinEdge(.trailing, to: .trailing, of: view)
    }
    
    @objc func neighborhoodViewSelected() {
        let viewController = builder.neighborhoodSearchViewController(delegate: self)
        present(viewController, animated: true, completion: nil)
    }
    
}

// MARK: - NeighborhoodSearchViewControllerDelegate
extension OnboardingNeighborhoodEditorViewController: NeighborhoodSearchViewControllerDelegate {
    
    func neighborhoodSearchViewController(_ viewController: NeighborhoodSearchViewController,
                                          didSelectNeighborhood neighborhood: String) {
        neighborhoodView.setInformation(neighborhood)
        viewModel.set(neighborhood: neighborhood)
        viewController.dismiss(animated: true)
    }
    
    func neighborhoodSearchViewControllerCancelTouchUpInside(_ viewController: NeighborhoodSearchViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - OnboardingNeighborhoodEditorViewDelegate
extension OnboardingNeighborhoodEditorViewController: OnboardingNeighborhoodEditorViewDelegate {
    
    func display(neighborhood: String) {
       neighborhoodView.setInformation(neighborhood)
    }
    
    func isLoading(_ loading: Bool) {
        buttonsView.isLoading(loading)
    }
    
    func neighborhoodUpdateFailed(with error: Error?) {
        presentAlertController(withNetworkError: error)
    }
   
    func neighborhoodUpdated() {
        goToNextStep()
        viewModel.resetAnalyticsProperties()
    }

}

// MARK: - OnboardingButtonsViewDelegate
extension OnboardingNeighborhoodEditorViewController: OnboardingButtonsViewDelegate {
    
    func backButtonSelected() {
        goToPreviousStep()
    }
    
    func nextButtonSelected() {
        viewModel.uploadNeighborhoodToProfile()
    }
    
}
