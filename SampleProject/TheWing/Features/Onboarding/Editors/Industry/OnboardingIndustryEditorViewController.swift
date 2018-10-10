//
//  OnboardingIndustryEditorViewController.swift
//  TheWing
//
//  Created by Luna An on 7/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingIndustryEditorViewController: OnboardingBaseEditorViewController {
    
    // MARK: - Public Properties
    
    /// Onboarding industry editor view model.
    var viewModel: OnboardingIndustryEditorViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override var progressStep: OnboardingProgressStep? {
        return .industry
    }
    
    override var analyticsProperties: [String: Any] {
        return viewModel.analyticsProperties
    }
    
    // MARK: - Private Properties
    
    private lazy var buttonsView = OnboardingButtonsView(theme: theme, delegate: self)
    
    private lazy var titleLabel: UILabel = {
        let textStyle = theme.textStyleTheme.headline1.withColor(theme.colorTheme.primary).withEmFont()
        return UILabel(text: OnboardingLocalization.industryScreenTitle, using: textStyle)
    }()
    
    private lazy var industryTextFieldPicker: TextFieldPicker = {
        let pickerBuilder = EditProfilePickerBuilder(theme: theme, superView: view)
        let title = OnboardingLocalization.industryPickerTitle
        return pickerBuilder.buildIndustryPicker(delegate: self, placeholder: title, floatingTitle: title)
    }()
    
    // MARK: - Public Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.loadIndustries()
        delegate?.editorViewController(viewController: self, updateStage: .basics(.inProgress))
    }
    
}

// MARK: - Private Functions
private extension OnboardingIndustryEditorViewController {
    
    func setupView() {
        view.backgroundColor = theme.colorTheme.invertTertiary
        setupButtonsView()
        setupTitle()
        setupPicker()
    }
    
    func textFieldPickerItemSelected(item: String, textFieldPicker: TextFieldPicker) {
        viewModel.set(industry: item)
    }
    
    private func setupButtonsView() {
        view.addSubview(buttonsView)
        buttonsView.autoPinEdgesToSuperviewEdges(excludingEdge: .bottom)
    }

    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.autoPinEdge(.top, to: .bottom, of: buttonsView)
        titleLabel.autoPinEdge(.leading, to: .leading, of: view, withOffset: ViewConstants.defaultGutter)
        titleLabel.autoPinEdge(.trailing, to: .trailing, of: view, withOffset: -ViewConstants.defaultGutter)
    }
    
    private func setupPicker() {
        view.addSubview(industryTextFieldPicker.fieldView)
        industryTextFieldPicker.fieldView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 36)
        industryTextFieldPicker.fieldView.autoPinEdge(.leading, to: .leading, of: view)
        industryTextFieldPicker.fieldView.autoPinEdge(.trailing, to: .trailing, of: view)
    }

}

// MARK: - TextFieldPickerDelegate
extension OnboardingIndustryEditorViewController: TextFieldPickerDelegate {
    
    func didSelectPickerItem(item: String, textFieldPicker: TextFieldPicker) {
        textFieldPicker.fieldView.set(text: item)
        textFieldPickerItemSelected(item: item, textFieldPicker: textFieldPicker)
    }
    
    func didSelectDone(textFieldPicker: TextFieldPicker) {
        textFieldPicker.pickerView?.resignFirstResponder()
    }

}

// MARK: - OnboardingIndustryViewDelegate
extension OnboardingIndustryEditorViewController: OnboardingIndustryViewDelegate {
    
    func displayIndustries(industries: [String], selectedIndex: Int?) {
        industryTextFieldPicker.display(items: industries, selectedIndex: selectedIndex)
    }
    
    func loadingIndustries(loading: Bool) {
        industryTextFieldPicker.pickerView?.isLoading = loading
    }
    
    func showNextButton(show: Bool) {
        buttonsView.showNextButton(show: show)
    }
    
    func isLoading(_ loading: Bool) {
        buttonsView.isLoading(loading)
    }
    
    func industryUpdated() {
        goToNextStep()
        viewModel.resetAnalyticsProperties()
    }

    func industryUpdateFailed(with error: Error?) {
        presentAlertController(withNetworkError: error)
    }
    
}

// MARK: - OnboardingButtonsViewDelegate
extension OnboardingIndustryEditorViewController: OnboardingButtonsViewDelegate {
    
    func backButtonSelected() {
        goToPreviousStep()
    }
    
    func nextButtonSelected() {
        viewModel.uploadIndustryToProfile()
    }
    
}
