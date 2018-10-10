//
//  BaseModalCardView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class BaseModalCardView: BuildableView {

    // MARK: - Public Properties

    weak var delegate: BaseModalCardDelegate?

    // MARK: - Private Properties

    private var titleLabel = UILabel()

    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(#imageLiteral(resourceName: "modal_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeSelected), for: .touchUpInside)
        return closeButton
    }()

    private var cardView: ModalCardView
    private var bottomModalView: BottomModalView
    private var topImageView = UIImageView()
    private var bottomImageView = UIImageView()
    private weak var modal: EventModal?
    
    // MARK: - Constants

    fileprivate static var closeButtonOffset: CGFloat = 16

    // MARK: - Initialization

    init(theme: Theme,
         modal: EventModal,
         cardView: ModalCardView,
         bottomModalView: BottomModalView,
         topImage: UIImage,
         bottomImage: UIImage? =  nil) {
        self.bottomModalView = bottomModalView
        self.cardView = cardView
        self.modal = modal
        topImageView.image = topImage
        bottomImageView.image = bottomImage
        super.init(theme: theme)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Sets the title of the title label.
    ///
    /// - Parameter title: Title string to set on the label.
    func set(title: String) {
        titleLabel.setText(title, using: theme.textStyleTheme.headline3)
    }

}

// MARK: - Private Functions
private extension BaseModalCardView {

    func setupView() {
        setupDesign()
        setupTitleLabel()
        setupCloseButton()
        setupCardContainerView()
        setupBottomModalView()
        setupTopImageView()
        setupBottomImageView()
    }

    func setupDesign() {
        backgroundColor = theme.colorTheme.invertTertiary
        layer.shadowColor = theme.colorTheme.emphasisQuintary.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -9)
        layer.shadowRadius = 30.0
        layer.shadowOpacity = 0.2
    }

    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.autoSetDimension(.height, toSize: 24)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        titleLabel.autoPinEdge(.top, to: .top, of: self, withOffset: 29)
    }

    func setupCloseButton() {
        addSubview(closeButton)
        closeButton.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        closeButton.autoPinEdge(.top, to: .top, of: self, withOffset: BaseModalCardView.closeButtonOffset)
        closeButton.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -BaseModalCardView.closeButtonOffset)
    }

    func setupCardContainerView() {
        addSubview(cardView)
        cardView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 28)
        cardView.autoPinEdge(.leading, to: .leading, of: self)
        cardView.autoPinEdge(.trailing, to: .trailing, of: self)
    }

    func setupBottomModalView() {
        addSubview(bottomModalView)
        
        let offset: CGFloat = bottomModalView.hasImage ? 10 : 23
        bottomModalView.autoPinEdge(.top, to: .bottom, of: cardView, withOffset: offset)
        bottomModalView.autoPinEdge(.leading, to: .leading, of: self)
        bottomModalView.autoPinEdge(.trailing, to: .trailing, of: self)
        bottomModalView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -40)
    }

    func setupTopImageView() {
        addSubview(topImageView)
        topImageView.contentMode = .scaleAspectFit
        topImageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 18)
        topImageView.autoPinEdge(.bottom, to: .top, of: self, withOffset: 25)
    }
    
    func setupBottomImageView() {
        addSubview(bottomImageView)
        bottomImageView.contentMode = .scaleAspectFit
        bottomImageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 18)
        bottomImageView.autoPinEdge(.top, to: .bottom, of: self, withOffset: -11)
    }

    @objc func closeSelected() {
        delegate?.closeSelected(from: modal)
    }

}
