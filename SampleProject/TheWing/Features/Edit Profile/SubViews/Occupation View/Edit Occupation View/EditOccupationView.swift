//
//  EditOccupationView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EditOccupationView: UIView {

    // MARK: - Public Properties

    /// Current occupations to display.
    var occupations = [Occupation]() {
        didSet {
            reloadView(occupations: occupations)
        }
    }

    weak var delegate: EditOccupationDelegate?

    // MARK: - Private Properties

    private let theme: Theme

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0))
        return stackView
    }()

    private lazy var addOccupationButton: PlusButton = {
        let button = PlusButton(theme: theme)
        button.addTarget(self, action: #selector(addOccupationSelected), for: .touchUpInside)
        button.set(text: "ADD_OCCUPATION_TITLE".localized(comment: "Add Another Occupation"))
        return button
    }()

    private lazy var occupationButtonContainer: UIView = {
        let view = UIView()
        view.addSubview(addOccupationButton)
        addOccupationButton.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .trailing)
        return view
    }()

    // MARK: - Initialization

    init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
        backgroundColor = theme.colorTheme.invertTertiary
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Functions
private extension EditOccupationView {

    func reloadView(occupations: [Occupation]) {
        stackView.removeAllArrangedSubviews()
        for occupation in occupations {
            let itemView = EditOccupationItem(theme: theme,
                                              occupation: occupation,
                                              isRequired: occupation == occupations.first)
            itemView.delegate = self
            stackView.addArrangedSubview(itemView)
        }
        stackView.addArrangedSubview(occupationButtonContainer)
    }

    @objc func addOccupationSelected() {
        delegate?.addOccupationSelected()
    }

}

// MARK: - EditOccupationItemDelegate
extension EditOccupationView: EditOccupationItemDelegate {

    func editOccupationSelected(occupation: Occupation) {
        delegate?.editOccupationSelected(occupation: occupation)
    }

}
