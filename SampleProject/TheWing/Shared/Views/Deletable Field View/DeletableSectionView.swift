//
//  DeletableSectionView.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class DeletableSectionView: BuildableView {
    
    // MARK: - Public Properties
    
    weak var delegate: DeletableSectionViewDelegate?
    
    // MARK: - Private Properties
    
    private lazy var deletableView: DeletableFieldView = {
        let view = DeletableFieldView(theme: theme)
        view.delegate = self
        return view
    }()
    
    private lazy var titleLabel = UILabel()
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    
    /// Sets the section title, title, and subtitles.
    ///
    /// - Parameters:
    ///   - sectionTitle: Section title.
    ///   - title: Title.
    ///   - subtitle: Subtitle.
    func set(sectionTitle: String, title: String, subtitle: String) {
        titleLabel.setText(sectionTitle, using: theme.textStyleTheme.headline3)
        deletableView.set(title: title, subtitle: subtitle)
    }
    
}

// MARK: - Private Functions
private extension DeletableSectionView {
    
    func setupDesign() {
        setupTitleLabel()
        setupDeletableView()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        let gutter = ViewConstants.defaultGutter
        let insets = UIEdgeInsets(top: gutter, left: gutter, bottom: 0, right: gutter)
        titleLabel.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
    }
    
    private func setupDeletableView() {
        addSubview(deletableView)
        deletableView.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets, excludingEdge: .top)
        deletableView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 4)
    }
    
}

// MARK: - DeletableFieldViewDelegate
extension DeletableSectionView: DeletableFieldViewDelegate {
    
    func deleteSelected(_ deletableFieldView: DeletableFieldView) {
        delegate?.deleteSelected(self)
    }
    
}
