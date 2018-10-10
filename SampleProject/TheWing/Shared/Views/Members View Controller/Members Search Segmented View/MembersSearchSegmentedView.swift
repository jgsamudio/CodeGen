//
//  MembersSearchSegmentedView.swift
//  TheWing
//
//  Created by Luna An on 8/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class MembersSearchSegmentedView: BuildableView {
    
    // MARK: - Public Properties
    
    weak var delegate: MembersSearchSegmentedViewDelegate?
    
    // MARK: - Private Properties
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = MemberSearchCategory.searchCategories.map {$0.title.uppercased()}
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 4
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = colorTheme.primary
        segmentedControl.autoSetDimension(.height, toSize: 27)
        segmentedControl.addTarget(self, action: #selector(searchCategoryChanged), for: .valueChanged)
        let attributes = textStyleTheme.captionNormal.withStrongFont().withColor(colorTheme.primary).attributes
        segmentedControl.setTitleTextAttributes(attributes, for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: colorTheme.invertTertiary],
                                                for: .selected)
        return segmentedControl
    }()
    
    private lazy var membersCountLabel = UILabel()
    
    private lazy var bottomBorderView = UIView.dividerView(height: ViewConstants.lineSeparatorThickness,
                                                           color: colorTheme.tertiary)
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions

    /// Sets members count.
    ///
    /// - Parameters:
    ///   - count: Filtered member count.
    ///   - selectedSegmentIndex: Selected segment index.
    func setMembersCount(withCount count: Int, selectedSegmentIndex: Int) {
        membersCountLabel.setText(MembersLocalization.showMembersCountText(count: count).uppercased(),
                                  using: textStyleTheme.captionLarge.withStrongFont().withCharacterSpacing(0.9))
        segmentedControl.selectedSegmentIndex = selectedSegmentIndex
    }
    
}

// MARK: - Private Functions
private extension MembersSearchSegmentedView {
    
    func setupView() {
        NSLayoutConstraint.autoSetPriority(.required - 1) {
            setupSegmentedControl()
            setupMemberCountLabel()
            setupBottomBorder()
        }
    }
    
    private func setupSegmentedControl() {
        addSubview(segmentedControl)
        segmentedControl.autoPinEdge(.top, to: .top, of: self, withOffset: 42)
        segmentedControl.autoPinEdge(.leading, to: .leading, of: self, withOffset: ViewConstants.defaultGutter)
        segmentedControl.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -ViewConstants.defaultGutter)
    }
    
    private func setupMemberCountLabel() {
        addSubview(membersCountLabel)
        membersCountLabel.autoPinEdge(.top, to: .bottom, of: segmentedControl, withOffset: 20)
        membersCountLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: ViewConstants.defaultGutter)
    }
    
    private func setupBottomBorder() {
        addSubview(bottomBorderView)
        bottomBorderView.autoPinEdgesToSuperviewEdges(excludingEdge: .top)
        bottomBorderView.autoPinEdge(.top, to: .bottom, of: membersCountLabel, withOffset: 20)
    }
    
    @objc func searchCategoryChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case MemberSearchCategory.asks.rawValue:
            delegate?.segmentedItemSelected(category: .asks)
        case MemberSearchCategory.offers.rawValue:
            delegate?.segmentedItemSelected(category: .offers)
        default:
            delegate?.segmentedItemSelected(category: .all)
        }
    }
    
}
