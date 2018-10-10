//
//  SectionHeaderView.swift
//  TheWing
//
//  Created by Luna An on 3/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Profile section header view.
final class SectionHeaderView: BuildableView {
    
    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
    
    // MARK: - Public Properties
    
        let label = UILabel()
        return label
    }()
    
    private lazy var underlineView: UIView = {
        let underline = UIView()
        underline.backgroundColor = colorTheme.emphasisSecondary
        return underline
    }()
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets the title of the label property.
    ///
    /// - Parameters:
    ///   - title: The title text to display.
    ///   - activated: Determines if the view is active or not.
    func set(title: String, activated: Bool = true) {
        let color = activated ? colorTheme.emphasisQuintary : colorTheme.tertiary
        titleLabel.setText(title, using: textStyleTheme.headline3.withColor(color))

        underlineView.backgroundColor = activated ? colorTheme.emphasisSecondary : colorTheme.tertiary
    }
    
    /// Sets the view to shimmer.
    ///
    /// - Parameter shimmer: Shimmers, if set to true, false, otherwise.
    func setShimmer(_ shimmer: Bool) {
        startShimmer(shimmer)
    }

}

// MARK: - ShimmerProtocol
extension SectionHeaderView: ShimmerProtocol {

    var shimmerViews: [ShimmerView] {
        return [ShimmerView(underlineView), ShimmerView(titleLabel, style: .full, height: 13)]
    }

}

// MARK: - Private Functions
private extension SectionHeaderView {
    
    func setupDesign() {
        NSLayoutConstraint.autoSetPriority(.required - 1) {
            autoSetDimension(.height, toSize: 35)
            setupTitleLabel()
            setupUnderlineView()
        }
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.autoSetDimension(.height, toSize: 34)
        titleLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0),
                                                excludingEdge: .trailing)
    }
    
    func setupUnderlineView() {
        addSubview(underlineView)
        underlineView.autoSetDimensions(to: CGSize(width: 51.5, height: 1))
        underlineView.autoPinEdge(.top, to: .bottom, of: titleLabel)
        underlineView.autoPinEdge(.leading, to: .leading, of: self)
        underlineView.autoPinEdge(.bottom, to: .bottom, of: self)
    }
    
}
