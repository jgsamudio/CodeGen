//
//  DeletableFieldView.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class DeletableFieldView: BuildableView {

    // MARK: - Public Properties

    /// Delegate.
    weak var delegate: DeletableFieldViewDelegate?
    
    // MARK: - Private Properties
    
    private lazy var titleLabel = UILabel(numberOfLines: 0)
    
    private lazy var subtitleLabel = UILabel(numberOfLines: 0)
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "delete_button"), for: .normal)
        button.addTarget(self, action: #selector(deleteSelected), for: .touchUpInside)
        button.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        return button
    }()
    
    private lazy var separatorLine = UIView.dividerView(height: ViewConstants.lineSeparatorThickness,
                                                        color: theme.colorTheme.tertiary)
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    
    /// Sets the title label and subtitle label given string inputs.
    ///
    /// - Parameters:
    ///   - title: Title string.
    ///   - subtitle: Subtitle string.
    func set(title: String, subtitle: String) {
        titleLabel.setText(title, using: theme.textStyleTheme.bodySmall.withColor(theme.colorTheme.emphasisQuintary))
        subtitleLabel.setText(subtitle, using: theme.textStyleTheme.bodyTiny)
    }
    
}

// MARK: - Private Functions
private extension DeletableFieldView {
    
    func setupDesign() {
        setupTitleLabel()
        setupDeleteButton()
        setupSubtitleLabel()
        setupSeparatorLine()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
    }
    
    private func setupDeleteButton() {
        addSubview(deleteButton)
        deleteButton.autoPinEdge(.top, to: .top, of: titleLabel, withOffset: -4)
        deleteButton.autoPinEdge(toSuperviewEdge: .trailing)
        titleLabel.autoPinEdge(.trailing, to: .leading, of: deleteButton, withOffset: 0)
    }
    
    private func setupSubtitleLabel() {
        addSubview(subtitleLabel)
        subtitleLabel.autoPinEdge(toSuperviewEdge: .leading)
        subtitleLabel.autoPinEdge(.top, to: .bottom, of: titleLabel)
        subtitleLabel.autoPinEdge(.trailing, to: .leading, of: deleteButton, withOffset: 0)
    }
    
    private func setupSeparatorLine() {
        addSubview(separatorLine)
        separatorLine.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        separatorLine.autoPinEdge(.top, to: .bottom, of: subtitleLabel, withOffset: 8)
    }
    
    @objc func deleteSelected() {
        delegate?.deleteSelected(self)
    }
    
}
