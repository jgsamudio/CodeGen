//
//  MemberCellView.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/25/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class MemberCellView: BuildableView {
    
    // MARK: - Private Properties

    private lazy var mainStackView: UIStackView = {
    
    // MARK: - Public Properties
    
        let stackView = UIStackView(arrangedSubviews: [topDividerView,
                                                       imageAndInfoStackView,
                                                       offeringAskingView,
                                                       offeringSupermatchDivider,
                                                       superMatchView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var lineSeparatorView = UIView.dividerView(height: ViewConstants.lineSeparatorThickness,
                                                            color: colorTheme.tertiary)
    
    private lazy var topDividerView = UIView.dividerView(height: 18, priority: .defaultHigh)
    private lazy var headDividerView = UIView.dividerView(width: 0, priority: .defaultHigh)
    private lazy var tailDividerView = UIView.dividerView(width: 0, priority: .defaultHigh)
    private lazy var offeringSupermatchDivider = UIView.dividerView(height: 8, priority: .defaultHigh)
    
    private lazy var imageAndInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headDividerView,
                                                       imageContainerView,
                                                       memberInfoStackView,
                                                       tailDividerView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var memberInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel,
                                                       headlineLabel,
                                                       industryLabel,
                                                       homebaseView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 2
        stackView.setCustomSpacing(4, after: industryLabel)
        return stackView
    }()
    
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.autoSetDimension(.width, toSize: MemberCellView.imageSize)
        view.addSubview(imageView)
        imageView.autoPinEdge(.top, to: .top, of: view)
        imageView.autoPinEdge(.leading, to: .leading, of: view)
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "avatar"))
        imageView.contentMode = .scaleAspectFill
        imageView.autoSetDimensions(to: CGSize(width: MemberCellView.imageSize, height: MemberCellView.imageSize))
        imageView.layer.cornerRadius = MemberCellView.imageSize/2
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel = UILabel(numberOfLines: 0)
    private lazy var headlineLabel = UILabel(numberOfLines: 0)
    private lazy var industryLabel = UILabel(numberOfLines: 0)
    private lazy var homebaseLabel = UILabel(numberOfLines: 0)
    
    private lazy var homebaseIconImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "homebase_icon"))
        imageView.autoSetDimensions(to: CGSize(width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var homebaseView: UIView = {
        let view = UIView()
        view.addSubview(homebaseIconImageView)
        view.addSubview(homebaseLabel)
        NSLayoutConstraint.autoSetPriority(.defaultHigh, forConstraints: {
            view.autoSetDimension(.height, toSize: 24)
        })
        homebaseIconImageView.autoPinEdge(.leading, to: .leading, of: view)
        homebaseIconImageView.autoAlignAxis(.horizontal, toSameAxisOf: view)
        homebaseLabel.autoAlignAxis(.horizontal, toSameAxisOf: homebaseIconImageView)
        homebaseLabel.autoPinEdge(.leading, to: .trailing, of: homebaseIconImageView, withOffset: 5)
        homebaseLabel.autoPinEdge(.trailing, to: .trailing, of: view)
        return view
    }()

    private lazy var offeringAskingView = MemberCellOfferingAskingView(theme: theme)
    
    private lazy var superMatchView = SuperMatchView(theme: theme)
    
    // MARK: - Constants
    
    private static let imageSize: CGFloat = 54

    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets the view with member info passed.
    ///
    /// - Parameters:
    ///   - memberInfo: Member info for the cell.
    ///   - category: Member search category.
    func setup(memberInfo: MemberInfo?,
               category: MemberSearchCategory = .unfiltered,
               isLoading: Bool) {
        setupMember(with: memberInfo, category: category, isLoading: isLoading)
        setupView(for: isLoading)
    }
    
    /// Cancels network request to load image.
    func cancelImageRequest() {
        imageView.af_cancelImageRequest()
        imageView.image = #imageLiteral(resourceName: "avatar")
    }
    
}

// MARK: - ShimmerProtocol
extension MemberCellView: ShimmerProtocol {

    var shimmerViews: [ShimmerView] {
        return [ShimmerView(homebaseLabel, style: .short, height: 7),
                ShimmerView(nameLabel, style: .long, height: 13),
                ShimmerView(headlineLabel, style: .medium, height: 9),
                ShimmerView(industryLabel, style: .short, height: 9)]
    }

    var shimmerImageViews: [ShimmerImageView] {
        return [ShimmerImageView(homebaseIconImageView, image: #imageLiteral(resourceName: "homebase_icon"), shimmerImage: #imageLiteral(resourceName: "loading_dot")), ShimmerImageView(imageView)]
    }

}

// MARK: - Private Functions
private extension MemberCellView {
    
    func setupDesign() {
        superMatchView.matchViewColor = colorTheme.secondary
        setupStackView()
        setupLineSeparator()
    }

    func setupMember(with memberInfo: MemberInfo?, category: MemberSearchCategory, isLoading: Bool) {
        guard let memberInfo = memberInfo else {
            return
        }

        setOffersAsksView(offers: memberInfo.offers,
                          asks: memberInfo.asks,
                          category: category)
        setNameLabel(name: memberInfo.name)
        setHeadlineLabel(headline: memberInfo.headline)
        setIndustryLabel(industry: memberInfo.industry?.name, memberInfo: memberInfo)
        setHomebaseLabel(homebase: memberInfo.homebase?.name)
        superMatchView.setup(description: isLoading ? nil : memberInfo.superMatchDescription)
        setImage(url: memberInfo.imageURL)
    }

    func setupView(for isLoading: Bool) {
        if isLoading {
            offeringAskingView.isHidden = true
            superMatchView.isHidden = true
        }
        startShimmer(isLoading)
    }

    func setupStackView() {
        addSubview(mainStackView)
        mainStackView.autoPinEdgesToSuperviewEdges()
        NSLayoutConstraint.autoSetPriority(.defaultHigh) {
            memberInfoStackView.autoSetDimension(.height, toSize: 70, relation: .greaterThanOrEqual)
            nameLabel.autoSetDimension(.height, toSize: 22)
        }
    }
    
    func setupLineSeparator() {
        addSubview(lineSeparatorView)
        lineSeparatorView.autoPinEdgesToSuperviewEdges(excludingEdge: .top)
    }
    
    func setImage(url: URL?) {
        guard let imageURL = url else {
            imageView.image = #imageLiteral(resourceName: "avatar")
            return
        }
        
        imageView.loadImage(from: imageURL)
    }

    func setOffersAsksView(offers: [String]?, asks: [String]?, category: MemberSearchCategory) {
        switch category {
        case .unfiltered:
            offeringAskingView.isHidden = true
            offeringAskingView.setup(offers: [], asks: [])
        case .offers:
            offeringAskingView.isHidden = false
            offeringAskingView.setup(offers: offers ?? [], asks: [])
        case .asks:
            offeringAskingView.isHidden = false
            offeringAskingView.setup(offers: [], asks: asks ?? [])
        default:
            offeringAskingView.isHidden = false
            offeringAskingView.setup(offers: offers ?? [], asks: asks ?? [])
        }
    }

    func setNameLabel(name: String) {
        nameLabel.setText(name, using: textStyleTheme.headline4.withColor(colorTheme.emphasisQuintary))
    }
    
    func setHeadlineLabel(headline: String?) {
        if let headline = headline, !headline.isEmpty {
            headlineLabel.isHidden = false
            headlineLabel.setText(headline, using: textStyleTheme.bodySmall)
        } else {
            headlineLabel.isHidden = true
        }
    }
    
    func setIndustryLabel(industry: String?, memberInfo: MemberInfo) {
        guard let industry = industry, !industry.isEmpty else {
            if memberInfo.homebase?.name.nilIfEmpty == nil {
                industryLabel.isHidden = false
                industryLabel.text = " "
                return
            }
            industryLabel.isHidden = true
            return
        }
    
        industryLabel.isHidden = false
        industryLabel.setMarkdownText("**\(industry.uppercased())**",
            using: textStyleTheme.captionNormal.withColor(colorTheme.emphasisSecondary))
    }
    
    func setHomebaseLabel(homebase: String?) {
        guard let homebase = homebase, !homebase.isEmpty else {
            homebaseView.isHidden = true
            return
        }
        
        homebaseView.isHidden = false
        homebaseLabel.setText(homebase, using: textStyleTheme.subheadlineLarge.withColor(colorTheme.emphasisQuaternaryMuted))
    }

}
