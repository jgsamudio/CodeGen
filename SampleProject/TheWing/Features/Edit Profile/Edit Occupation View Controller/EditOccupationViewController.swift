//
//  EditOccupationViewController.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Pilas

final class EditOccupationViewController: BuildableViewController {

    // MARK: - Public Properties

    var viewModel: EditOccupationViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    weak var delegate: EditOccupationBaseDelegate?
    
    // MARK: - Private Properties

    private lazy var scrollView: PilasScrollView = {
        let scrollView = PilasScrollView()
        view.addSubview(scrollView)
        let gutter = ViewConstants.defaultGutter
        let insets = UIEdgeInsets(top: 0, left: gutter, bottom: 0, right: gutter)
        scrollView.autoPinEdgesToSuperviewEdges(with: insets)
        return scrollView
    }()

    private lazy var saveButton: UIBarButtonItem = {
        let saveButtonTitle = "SAVE".localized(comment: "Save changes")
        let saveButton = UIBarButtonItem(title: saveButtonTitle,
                                         style: .plain,
                                         target: viewModel,
                                         action: #selector(viewModel.saveOccupation))
        let textStyle = theme.textStyleTheme.bodyNormal.withStrongFont()
        let normalTextStyle = textStyle.withColor(theme.colorTheme.emphasisPrimary)
        let disabledTextStyle = textStyle.withColor(theme.colorTheme.tertiary)
        saveButton.setTitleTextStyle(with: disabledTextStyle, for: .disabled)
        saveButton.setTitleTextStyle(with: normalTextStyle, for: .normal)
        saveButton.isEnabled = false
        return saveButton
    }()

    private lazy var positionTextField: UnderlinedFloatLabeledTextField = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldSelected))
        return UnderlinedFloatLabeledTextField(placeholder: "POSITION_REQUIRED".localized(comment: "Position (required)"),
                                               gesture: tapGesture,
                                               theme: theme)

    }()

    private lazy var companyTextField: UnderlinedFloatLabeledTextField = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldSelected))
        return UnderlinedFloatLabeledTextField(placeholder: "COMPANY".localized(comment: "Company"),
                                               gesture: tapGesture,
                                               theme: theme)
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        let textStyle = theme.textStyleTheme.bodyNormal.withColor(theme.colorTheme.errorPrimary)
        button.setTitleText("DELETE_TITLE".localized(comment: "Delete"), using: textStyle)
        button.addTarget(viewModel, action: #selector(viewModel.deleteOccupation), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    // MARK: - Public Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        viewModel.loadOccupation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

}

// MARK: - Private Functions
private extension EditOccupationViewController {

    func setupDesign() {
        view.backgroundColor = theme.colorTheme.invertTertiary

        scrollView.insertDividerView(height: 22)
        scrollView.insertView(view: positionTextField)
        scrollView.insertView(view: companyTextField)
        scrollView.insertDividerView(height: 28)
        scrollView.insertView(view: deleteButton)
    }

    func setupNavigationBar() {
        navigationController?.setNavigationBar(backgroundColor: theme.colorTheme.invertTertiary,
                                               tintColor: theme.colorTheme.emphasisPrimary,
                                               textStyle: theme.textStyleTheme.headline3)
        navigationItem.title = viewModel.navigationTitle
        let cancelButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close_button"), style: .plain, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }

    @objc func dismissView() {
        if navigationController?.viewControllers.first == navigationController?.visibleViewController {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc func textFieldSelected(sender: Any) {
        guard let sender = sender as? UITapGestureRecognizer,
              let textField = sender.view as? UnderlinedFloatLabeledTextField  else {
            return
        }

        if textField == positionTextField {
            addPositionSelected()
        } else if textField == companyTextField {
            addCompanySelected()
        }
    }
    
    func addPositionSelected() {
        let viewController = builder.searchPositionViewController(delegate: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func addCompanySelected() {
        let viewController = builder.searchCompanyViewController(delegate: self)
        navigationController?.pushViewController(viewController, animated: true)
    }

}

// MARK: - EditOccupationViewDelegate
extension EditOccupationViewController: EditOccupationViewDelegate {

    func display(position: String?, company: String?) {
        positionTextField.textField.text = position
        companyTextField.textField.text = company
    }
    
    func set(selection: String?, type: SearchOccupationType) {
        switch type {
        case .positions:
            positionTextField.textField.text = selection
            viewModel.editableOccupation?.position = selection
        case .companies:
            companyTextField.textField.text = selection
            viewModel.editableOccupation?.company = selection
        }
    }
    
    func returnToEditProfile(position: String, company: String?, deleted: Bool) {
        dismissView()
        let occupation = Occupation(company: company, occupationId: "", position: position)
        delegate?.setOccupation(occupation: occupation, originalOccupation: viewModel.occupation, deleted: deleted)
    }
    
    func canSaveOccupation(_ canSave: Bool) {
        saveButton.isEnabled = canSave
    }
    
    func displayDelete() {
        deleteButton.isHidden = false
    }

}
