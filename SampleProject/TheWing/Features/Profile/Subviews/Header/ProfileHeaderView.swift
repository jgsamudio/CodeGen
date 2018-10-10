//
//  ProfileHeaderView.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Header for profile view.
final class ProfileHeaderView: UIView {
    
    // MARK: - Public Properties
    
    /// Profile header view delegate.
    weak var delegate: ProfileHeaderViewDelegate?
    
    // MARK: - Private Properties
    
    private let theme: Theme
    
    private let nameDivider = UIView.dividerView(height: 10)
    private let headlineDivider = UIView.dividerView(height: 16)
    private let linksDivider = UIView.dividerView(height: 24)
    
    private var links: [SocialLink] = [] {
        didSet {
            configureLinksStackView()
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    private lazy var imageView: DoubleBorderedImageView = {
        let imageSize = ProfileHeaderView.imageSize
        let borderSpacing = ProfileHeaderView.imageBorderSpacing
        let imageView = DoubleBorderedImageView(theme: theme)
        imageView.borderSpacing = borderSpacing
        imageView.autoSetDimensions(to: imageSize)
        imageView.cornerRadius = ProfileHeaderView.imageSize.height / 2
        imageView.image = #imageLiteral(resourceName: "avatar")
        return imageView
    }()
    
    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel(numberOfLines: 0)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var headlineLabel: UILabel = {
        let label = UILabel(numberOfLines: 0)
        label.lineBreakMode = .byWordWrapping
        label.isHidden = true
        return label
    }()
    
    private lazy var linksStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 32
        stackView.isHidden = true
        return stackView
    }()

    // MARK: - Constants
    
    private static let gutter: CGFloat = 16
    private static let imageSize = CGSize(width: 128, height: 128)
    private static let imageBorderSpacing: CGFloat = 4
    private static let linkButtonSize = CGSize(width: 30, height: 30)
    
    // MARK: - Initialization
    
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: .zero)
        
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions

    func setName(_ name: String) {
        nameLabel.setText(name, using: theme.textStyleTheme.displaySmall.withAlignment(.center))
    }
    
    func setImage(with imageURL: URL?) {
        guard let url = imageURL else {
            return
        }
        
        imageView.setImage(url: url)
    }
    
    func setHeadline(_ headline: String?) {
        guard let headline = headline else {
            headlineLabel.isHidden = true
            headlineDivider.isHidden = true
            return
        }

        headlineLabel.setText(headline, using: theme.textStyleTheme.bodyLarge.withAlignment(.center))
        headlineLabel.isHidden = false
        headlineDivider.isHidden = false
    }
    
    func setLinks(_ links: [SocialLink]) {
        self.links = links
    }

}

// MARK: - Private Functions
private extension ProfileHeaderView {
    
    func setupDesign() {
        setupStackView()
    }
    
    func setupStackView() {
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0,
                                                                  left: ProfileHeaderView.gutter,
                                                                  bottom: 40,
                                                                  right: ProfileHeaderView.gutter))
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameDivider)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(headlineDivider)
        stackView.addArrangedSubview(headlineLabel)
        stackView.addArrangedSubview(linksDivider)
        stackView.addArrangedSubview(linksStackView)
    }

    func configureLinksStackView() {
        linksStackView.removeAllArrangedSubviews()

        guard !links.isEmpty else {
            linksStackView.isHidden = true
            linksDivider.isHidden = true
            return
        }
        links.forEach { addSocialLinkButton($0) }
        linksStackView.isHidden = false
        linksDivider.isHidden = false
    }
    
    @objc func linkTouchUpInside(_ sender: UIButton) {
        guard let index = linksStackView.arrangedSubviews.index(of: sender),
            links.indices.contains(index) else {
            fatalError("Unreachable social link.")
        }

        delegate?.visit(links[index])
    }
    
    func addSocialLinkButton(_ link: SocialLink) {
        let button = UIButton()
        button.addTarget(self, action: #selector(linkTouchUpInside(_:)), for: .touchUpInside)
        button.autoSetDimensions(to: ProfileHeaderView.linkButtonSize)
        button.setImage(link.icon, for: .normal)
        linksStackView.addArrangedSubview(button)
    }

}
