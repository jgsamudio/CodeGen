//
//  OnboardingOccupationEditorViewController.swift
//  TheWing
//
//  Created by Luna An on 7/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Pilas

final class OnboardingOccupationEditorViewController: OnboardingBaseEditorViewController {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    var viewModel: OnboardingOccupationEditorViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    /// Progress step.
    override var progressStep: OnboardingProgressStep? {
        return .occupation
     }
    
    override var analyticsProperties: [String: Any] {
        return viewModel.analyticsProperties
    }
    
    // MARK: - Private Properties
    
    private lazy var buttonsView = OnboardingButtonsView(theme: theme, delegate: self)
    
    private lazy var scrollView = PilasScrollView(alignment: .fill, distribution: .fill, axis: .vertical)
    
    private lazy var titleLabel: UILabel = {
        let textStyle = theme.textStyleTheme.headline1.withColor(theme.colorTheme.primary).withEmFont()
        return UILabel(text: OnboardingLocalization.occupationScreenTitle, using: textStyle)
    }()

    private lazy var titleContainerView: UIView = {
        let view = UIView()
        view.addSubview(titleLabel)
        titleLabel.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets)
        return view
    }()
    
    private lazy var occupationView: EditOccupationView = {
        let view = EditOccupationView(theme: theme)
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    private lazy var emptyOccupationView: EditEmptyOccupationView = {
        let view = EditEmptyOccupationView(theme: theme)
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    // MARK: - Public Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.loadOccupations()
        delegate?.editorViewController(viewController: self, updateStage: .basics(.inProgress))
    }
    
}

// MARK: - Private Functions
private extension OnboardingOccupationEditorViewController {
    
    func setupView() {
        view.backgroundColor = theme.colorTheme.invertTertiary
        delegate?.editorViewController(viewController: self,
                                       setProgressViewIsHidden: false,
                                       collapse: false,
                                       animated: true,
                                       completion: nil)
        setupScrollView()
        setupButtonsView()
    }
    
    func showOccupations(_ show: Bool) {
        occupationView.isHidden = !show
        emptyOccupationView.isHidden = show
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.autoPinEdgesToSuperviewEdges(excludingEdge: .top)
        scrollView.autoPinEdge(.top, to: .top, of: view, withOffset: 85)
        scrollView.insertView(view: titleContainerView)
        scrollView.insertView(view: UIView.dividerView(height: 30))
        scrollView.insertView(view: occupationView)
        scrollView.insertView(view: emptyOccupationView)
    }
    
    private func setupButtonsView() {
        view.addSubview(buttonsView)
        buttonsView.autoPinEdgesToSuperviewEdges(excludingEdge: .bottom)
        buttonsView.showNextButton(show: true)
    }

}

// MARK: - OnboardingOccupationEditorViewDelegate
extension OnboardingOccupationEditorViewController: OnboardingOccupationEditorViewDelegate {
    
    func setOccupation(occupation: Occupation?, originalOccupation: Occupation?, deleted: Bool) {
        viewModel.updateOccupations(occupation: occupation,
                                    originalOccupation: originalOccupation,
                                    deleted: deleted)
    }

    func occupationsUpdated() {
        goToNextStep()
        viewModel.resetAnalyticsProperties()
    }
    
    func occupationsUpdateFailed(with error: Error?) {
        presentAlertController(withNetworkError: error)
    }
    
    func isLoading(_ loading: Bool) {
        buttonsView.isLoading(loading)
    }
    
    func displayEmptyOccupationView() {
        showOccupations(false)
    }
    
    func displayOccupationItemView(occupations: [Occupation]) {
        showOccupations(true)
        occupationView.occupations = occupations
    }
    
    func showNextButton(show: Bool) {
        buttonsView.showNextButton(show: show)
    }
    
}

// MARK: - OnboardingButtonsViewDelegate
extension OnboardingOccupationEditorViewController: OnboardingButtonsViewDelegate {
    
    func backButtonSelected() {
        goToPreviousStep()
    }
    
    func nextButtonSelected() {
        viewModel.updateProfile()
    }
    
}

// MARK: - EditOccupationDelegate
extension OnboardingOccupationEditorViewController: EditOccupationDelegate {
    
    func editOccupationSelected(occupation: Occupation) {
        let editOccupationViewController = builder.editOccupationViewController(delegate: self, occupation: occupation)
        presentNavigationController(with: editOccupationViewController)
    }
    
    func addOccupationSelected() {
        presentNavigationController(with: builder.addOccupationViewController(delegate: self))
    }
    
    private func presentNavigationController(with viewController: UIViewController) {
        let navigationController = builder.navigationController(with: viewController)
        navigationController.removeNavigationBarBorder()
        present(navigationController, animated: true, completion: nil)
    }
    
}

// MARK: - UIScrollViewDelegate
extension OnboardingOccupationEditorViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        buttonsView.layer.shadowOpacity = scrollView.navigationShadowOpacity
    }
    
}
