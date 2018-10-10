//
//  TaskCellView.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class TaskCellView: BuildableView {
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
    
    // MARK: - Public Properties
    
        let label = UILabel(numberOfLines: 0)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(numberOfLines: 0)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.colorTheme.invertTertiary
        view.layer.borderWidth = 1
        view.layer.borderColor = theme.colorTheme.emphasisSecondary.cgColor
        view.layer.applySketchShadow(color: theme.colorTheme.emphasisSecondaryFaded, shawdowY: 7, blur: 16)
        return view
    }()
    
    private lazy var button: StylizedButton = {
        let button = StylizedButton(buttonStyle: theme.buttonStyleTheme.secondaryDarkButtonStyle)
        button.autoSetDimension(.height, toSize: 32)
        button.contentEdgeInsets.left = ViewConstants.stylizedButtonTitleInset
        button.contentEdgeInsets.right = ViewConstants.stylizedButtonTitleInset
        button.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        return button
    }()
    
    private lazy var fancyFrameView: FancyFrameView = {
        let imageView = FancyFrameView(theme: theme)
        imageView.autoSetDimensions(to: CGSize(width: 140, height: 92))
        imageView.cornerRadius = 46
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.autoSetDimensions(to: TaskCellView.topViewSize)
        imageView.image = #imageLiteral(resourceName: "bookmark_task")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    private var buttonAction: (() -> Void)?
    
    // MARK: - Constants
    
    private static let gutter: CGFloat = 24
    
    private static let topViewSize = CGSize(width: 191, height: 95)
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets the cell with content in view options.
    ///
    /// - Parameter options: Cell view options.
    func setup(options: TaskCellViewOptions) {
        titleLabel.setMarkdownText("**\(options.title)**",
            using: theme.textStyleTheme.bodyLarge.withColor(theme.colorTheme.emphasisQuintary))
        descriptionLabel.setText(options.description, using: theme.textStyleTheme.bodySmall)
        button.setTitle(options.buttonTitle.uppercased())
        button.buttonStyle = options.buttonStyle
        imageView.isHidden = options.isFancy
        fancyFrameView.isHidden = !options.isFancy
        if let url = options.imageURL {
            options.isFancy ? fancyFrameView.setImage(url: url) : imageView.loadImage(from: url)
        }
    }
    
    /// Sets the action for the button.
    ///
    /// - Parameter action: Action block.
    func setAction(_ action: @escaping (() -> Void)) {
        buttonAction = action
    }
    
    /// Cancels any ongoing image requests.
    func cancelImageRequests() {
        imageView.af_cancelImageRequest()
        fancyFrameView.cancelImageRequest()
    }
    
}

// MARK: - Private Functions
private extension TaskCellView {
    
    @objc func buttonSelected() {
        buttonAction?()
    }
    
    func setupDesign() {
        setupBackgroundView()
        setupTopView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupButton()
    }
    
    private func setupBackgroundView() {
        addSubview(backgroundView)
        backgroundView.autoMatch(.height, to: .height, of: self, withMultiplier: 0.82)
        backgroundView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    private func setupTopView() {
        addSubview(fancyFrameView)
        fancyFrameView.autoConstrainAttribute(.marginAxisHorizontal,
                                              to: .top,
                                              of: backgroundView,
                                              withOffset: 0,
                                              relation: .equal)
        fancyFrameView.autoPinEdge(toSuperviewEdge: .leading, withInset: TaskCellView.gutter)
        addSubview(imageView)
        imageView.autoConstrainAttribute(.marginAxisHorizontal,
                                         to: .top,
                                         of: backgroundView,
                                         withOffset: -6,
                                         relation: .equal)
        imageView.autoPinEdge(toSuperviewEdge: .leading, withInset: TaskCellView.gutter)
    }
    
    private func setupTitleLabel() {
        backgroundView.addSubview(titleLabel)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: TaskCellView.gutter)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: TaskCellView.gutter)
        titleLabel.autoPinEdge(.top, to: .bottom, of: fancyFrameView, withOffset: 6)
    }
    
    private func setupDescriptionLabel() {
        backgroundView.addSubview(descriptionLabel)
        descriptionLabel.autoPinEdge(.leading, to: .leading, of: titleLabel)
        descriptionLabel.autoPinEdge(.trailing, to: .trailing, of: titleLabel)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 8)
        descriptionLabel.autoPinEdge(.bottom, to: .bottom, of: backgroundView, withOffset: -80, relation: .lessThanOrEqual)
    }
    
    private func setupButton() {
        backgroundView.addSubview(button)
        button.autoPinEdge(toSuperviewEdge: .trailing, withInset: TaskCellView.gutter)
        button.autoPinEdge(toSuperviewEdge: .bottom, withInset: TaskCellView.gutter)
    }
    
}
