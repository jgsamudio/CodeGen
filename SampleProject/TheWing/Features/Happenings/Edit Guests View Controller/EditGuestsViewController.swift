//
//  EditGuestsViewController.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Pilas

final class EditGuestsViewController: BuildableViewController {
    
    // MARK: - Public Properties
    
    /// View model.
    var viewModel: EditGuestsViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }

    // MARK: - Private Properties
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(numberOfLines: 0)
        label.setText("ADD_GUESTS_MESSAGE".localized(comment: "Add guests message"), using: theme.textStyleTheme.bodySmall)
        return label
    }()
    
    private lazy var infoLabel = UILabel(numberOfLines: 0)
    
    private lazy var addButton: UIButton = {
        let button = PlusButton(theme: theme)
        button.set(text: "ADD_MORE_GUESTS".localized(comment: "Add another guest").capitalized)
        button.addTarget(viewModel, action: #selector(viewModel.addGuestForm), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonContainer: UIView = {
        let container = UIView()
        container.addSubview(addButton)
        let insets = UIEdgeInsets(top: 8, left: -16, bottom: 0, right: 0)
        addButton.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .right)
        container.isHidden = true
        container.alpha = 0
        return container
    }()
    
    private lazy var descriptionContainer: UIView = {
        let container = UIView()
        container.addSubview(descriptionLabel)
        descriptionLabel.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets, excludingEdge: .bottom)
        container.addSubview(infoLabel)
        infoLabel.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets, excludingEdge: .top)
        infoLabel.autoPinEdge(.top, to: .bottom, of: descriptionLabel, withOffset: 8)
        return container
    }()
    
    private lazy var scrollView: PilasScrollView = {
        let scrollView = PilasScrollView()
        scrollView.alignment = .fill
        scrollView.distribution = .fill
        scrollView.axis = .vertical
        scrollView.enableKeyboardNotifications = true
        view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges()
        return scrollView
    }()
    
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "SAVE".localized(comment: "Save"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(save))
        let textStyle = theme.textStyleTheme.bodyNormal.withColor(theme.colorTheme.emphasisPrimary)
        button.setTitleTextStyle(with: textStyle, for: .normal)
        button.setTitleTextStyle(with: textStyle, for: .highlighted)
        button.setTitleTextStyle(with: textStyle.withColor(theme.colorTheme.emphasisQuintaryFaded), for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    private var formViews = [GuestFormView]()
    
    private var deletableViews = [DeletableSectionView]()
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        viewModel.loadGuestFlow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
    }
    
}

// MARK: - Private Functions
private extension EditGuestsViewController {
    
    func setupDesign() {
        addRecognizerForKeyboardDismissal()
        navigationController?.setNavigationBar(backgroundColor: theme.colorTheme.invertTertiary,
                                               tintColor: theme.colorTheme.emphasisPrimary,
                                               textStyle: theme.textStyleTheme.headline3)
        navigationItem.title = viewModel.title.capitalized
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close_button"),
                                                           style: .plain,
                                                           target: viewModel,
                                                           action: #selector(viewModel.cancelAction))
        navigationItem.rightBarButtonItem = saveButton
        scrollView.insertDividerView(height: 24)
        scrollView.insertView(view: descriptionContainer)
        scrollView.insertView(view: buttonContainer)
    }
    
    @objc func save() {
        analyticsProvider.track(event: AnalyticsEvents.Happenings.saveGuests.analyticsIdentifier,
                                properties: viewModel.analyticsProperties(forScreen: self),
                                options: nil)
        viewModel.save()
    }

}

// MARK: - EditGuestsViewDelegate
extension EditGuestsViewController: EditGuestsViewDelegate {
    
    func setAddEnabled(_ enabled: Bool) {
        buttonContainer.isHidden = !enabled
        UIView.animate(withDuration: AnimationConstants.defaultDuration, animations: {
            self.buttonContainer.alpha = enabled ? 1 : 0
        })
    }
    
    func displayInfo(message: String) {
        infoLabel.setMarkdownText("*\(message.uppercased())*", using: theme.textStyleTheme.captionBig)
    }
    
    func appendGuestForm() {
        let formView = GuestFormView(theme: theme)
        formView.delegate = self
        scrollView.insertDividerView(height: 32)
        scrollView.insertView(view: formView)
        formViews.append(formView)
    }
    
    func appendDeletableGuest(name: String, email: String) {
        let deletableView = DeletableSectionView(theme: theme)
        deletableView.delegate = self
        deletableView.set(sectionTitle: "GUEST".localized(comment: "Guest"), title: name, subtitle: email)
        scrollView.insertView(view: deletableView)
        deletableViews.append(deletableView)
    }
    
    func showError(in section: Int, at row: GuestFormRow, message: String) {
        formViews[section].showError(in: row, message: message)
    }
    
    func hideError(in section: Int, at row: GuestFormRow) {
        formViews[section].hideError(in: row)
    }
    
    func setSaveEnabled(_ enabled: Bool) {
        saveButton.isEnabled = enabled
    }
    
    func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func discardAttempt() {
        let discardTitle = "DISCARD_CONFIRMATION".localized(comment: "Discard Changes?")
        let discardAction = "ALERT_DISCARD_TITLE".localized(comment: "Discard")
        let discardMessage = "DISCARD_MESSAGE".localized(comment: "Are you sure you want to discard your changes?")
        let alert = UIAlertController.deleteActionAlertController(title: discardTitle,
                                                                  message: discardMessage,
                                                                  deleteTitle: discardAction) { (_) in
                                                                    self.dismiss(animated: true, completion: nil)
        }
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - GuestFormViewDelegate
extension EditGuestsViewController: GuestFormViewDelegate {
    
    func fieldDidEndEditing(_ formView: GuestFormView, at row: GuestFormRow) {
        if let index = formViews.index(of: formView) {
            viewModel.validateFormField(with: formView.text(in: row), in: index, at: row)
        }
    }

    func fieldEditingDidChange(_ formView: GuestFormView, at row: GuestFormRow) {
        if let index = formViews.index(of: formView) {
            viewModel.editGuest(with: formView.text(in: row), in: index, at: row)
        }
    }
    
}

// MARK: - DeletableSectionViewDelegate
extension EditGuestsViewController: DeletableSectionViewDelegate {
    
    func deleteSelected(_ deletableSectionView: DeletableSectionView) {
        if let index = deletableViews.index(of: deletableSectionView) {
            viewModel.deleteAction(in: index)
            deletableSectionView.removeFromSuperview()
            deletableViews.remove(at: index)
        }
    }
    
}

// MARK: - AnalyticsIdentifiable
extension EditGuestsViewController: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.editGuests.analyticsIdentifier
    }

}
