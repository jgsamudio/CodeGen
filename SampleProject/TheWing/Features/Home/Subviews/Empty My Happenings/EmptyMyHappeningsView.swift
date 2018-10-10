//
//  EmptyMyHappeningsView.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EmptyMyHappeningsView: BuildableView {

    // MARK: - Public Properties

    /// Delegate.
    weak var delegate: EmptyMyHappeningsViewDelegate?
    
    // MARK: - Private Properties

    private lazy var helperLabel: UILabel = {
        let label = UILabel(numberOfLines: 0)
        label.setText(HomeLocalization.noUpcomingHappenings, using: theme.textStyleTheme.bodyNormal.withAlignment(.center))
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "happenings_graphic"))
        imageView.autoSetDimension(.height, toSize: UIScreen.width * 0.40267)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var button: StylizedButton = {
        let button = StylizedButton(buttonStyle: theme.buttonStyleTheme.secondaryDarkButtonStyle)
        button.autoSetDimension(.height, toSize: ViewConstants.defaultButtonHeight)
        button.contentEdgeInsets.left = ViewConstants.stylizedButtonTitleInset
        button.contentEdgeInsets.right = ViewConstants.stylizedButtonTitleInset
        button.setTitle(HomeLocalization.seeWhatsHappening)
        button.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let subViews = [imageView, UIView.dividerView(height: 20), helperLabel, UIView.dividerView(height: 40), button]
        return UIStackView(arrangedSubviews: subViews,
                           axis: .vertical,
                           distribution: .equalSpacing,
                           alignment: .center,
                           spacing: 0)
    }()
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Functions
private extension EmptyMyHappeningsView {
    
    func setupView() {
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0))
    }
    
    @objc func buttonSelected() {
        delegate?.actionButtonSelected()
    }
    
}
