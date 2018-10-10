//
//  BottomModalView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class BottomModalView: BuildableView {
    
    // MARK: - Public Properties
    
    /// Indicates if the modal view includes an icon image.
    var hasImage = false
    
    // MARK: - Private Properties
    
    private let type: EventModalType

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var descriptionLabel = UILabel(numberOfLines: 0)
    
    private lazy var descriptionContainerView: UIView = {
        let view = UIView()
        view.addSubview(descriptionLabel)
        descriptionLabel.autoPinEdgesToSuperviewEdges(with: type.descriptionInsets)
        return view
    }()
    
    private var buttonContainerView: UIView?

    // MARK: - Constants

    fileprivate static var gutter: CGFloat = 24

    // MARK: - Initialization

    init(theme: Theme, type: EventModalType) {
        self.type = type
        super.init(theme: theme)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Sets up the view with the parameters below.
    ///
    /// - Parameters:
    ///   - icon: Icon to set the image view with.
    ///   - description: Description to set the label with.
    ///   - button: Button to set the action button with.
    func setup(icon: UIImage? = nil, description: String?, button: UIButton? = nil) {
        stackView.removeAllArrangedSubviews()
        stackView.isHidden = false
        set(icon: icon)
        set(description: description)
        set(button: button)
    }
    
    func setup(description: String, buttonView: UIView) {
        stackView.removeAllArrangedSubviews()
        stackView.isHidden = false
        set(description: description)
        set(buttonView: buttonView)
    }
    
    /// Sets up the empty view.
    func setupEmptyView() {
        stackView.removeAllArrangedSubviews()
        stackView.isHidden = true
    }

}

// MARK: - Private Functions
private extension BottomModalView {

    func setupView() {
        let insets = UIEdgeInsets(top: 0,
                                  left: BottomModalView.gutter,
                                  bottom: 0,
                                  right: BottomModalView.gutter)
        stackView.autoPinEdgesToSuperviewEdges(with: insets)
    }
    
    func set(icon: UIImage?) {
        guard let icon = icon else {
            hasImage = false
            iconImageView.isHidden = true
            return
        }
        
        hasImage = true
        iconImageView.autoSetDimension(.height, toSize: 30)
        iconImageView.isHidden = false
        iconImageView.image = icon
        stackView.addArrangedSubview(iconImageView)
    }

    func set(description: String?) {
        guard let description = description else {
            descriptionContainerView.isHidden = true
            return
        }
        
        let textStyle = theme.textStyleTheme.bodySmall.withAlignment(.center)
        descriptionLabel.setText(description, using: textStyle)
        stackView.addArrangedSubview(descriptionContainerView)
    }

    func set(button: UIButton?) {
        guard let button = button else {
            return
        }
        
        buttonContainerView = UIView()
        guard let containerView = buttonContainerView else {
            return
        }
        
        containerView.addSubview(button)
        button.autoPinEdge(.top, to: .top, of: containerView)
        button.autoPinEdge(.bottom, to: .bottom, of: containerView)
        button.autoAlignAxis(.vertical, toSameAxisOf: containerView)
        stackView.addArrangedSubview(containerView)
    }
    
    func set(buttonView: UIView?) {
        guard let buttonView = buttonView else {
            return
        }
        
        buttonContainerView = UIView()
        guard let containerView = buttonContainerView else {
            return
        }
        
        containerView.addSubview(buttonView)
        buttonView.autoPinEdgesToSuperviewEdges()
        stackView.addArrangedSubview(containerView)
    }

}
