//
//  OfferingAskingListView.swift
//  TheWing
//
//  Created by Luna An on 8/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OfferingAskingListView: BuildableView {
    
    // MARK: - Private Properties
    
    private lazy var stackView: UIStackView = {
    
    // MARK: - Public Properties
    
        let stackView = UIStackView(arrangedSubviews: [titleContainerView, skillsLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 18
        return stackView
    }()
    
    private lazy var titleContainerView: UIView = {
        let view = UIView()
        view.addSubview(titleLabel)
        titleLabel.autoPinEdge(toSuperviewEdge: .left)
        titleLabel.autoPinEdge(toSuperviewEdge: .right)
        titleLabel.autoPinEdge(.top, to: .top, of: view, withOffset: 2)
        view.autoSetDimension(.width, toSize: 68)
        view.autoMatch(.height, of: titleLabel)
        return view
    }()
    
    private lazy var titleLabel = UILabel()
    
    private lazy var skillsLabel: UILabel = {
        let label = UILabel(numberOfLines: 2)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets up the view.
    ///
    /// - Parameters:
    ///   - title: Title string.
    ///   - skills: Skills array.
    func setup(title: String, skills: [String]) {
        let textColor = colorTheme.tertiary
        let textStyle = textStyleTheme.captionNormal.withAlignment(.right).withColor(textColor).withCharacterSpacing(0.8)
        titleLabel.setMarkdownText("**\(title.uppercased())**", using: textStyle)
        skillsLabel.setText(skills.joined(separator: ", "), using: textStyleTheme.bodySmall)
    }
    
}

// MARK: - Private Functions
private extension OfferingAskingListView {
    
    func setupView() {
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges()
    }
    
}
