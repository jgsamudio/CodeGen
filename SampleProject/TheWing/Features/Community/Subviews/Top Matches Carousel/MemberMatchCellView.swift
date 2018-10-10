//
//  MemberMatchCellView.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Shimmer

final class MemberMatchCellView: BuildableView {
    
    // MARK: - Private Properties
    
    private lazy var imageView: UIImageView = {
    
    // MARK: - Public Properties
    
        let imageView = UIImageView(image: #imageLiteral(resourceName: "avatar"), contentMode: .scaleAspectFill)
        imageView.autoSetDimensions(to: CGSize(width: MemberMatchCellView.imageWidth,
                                               height: MemberMatchCellView.imageWidth))
        imageView.layer.cornerRadius = MemberMatchCellView.imageWidth/2
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var industryLabel = UILabel(numberOfLines: 1)
    
    private lazy var nameLabel = UILabel(numberOfLines: 3)
    
    private lazy var locationLabel = UILabel(numberOfLines: 1)

    private lazy var locationImageView = UIImageView(image: #imageLiteral(resourceName: "homebase_icon"), contentMode: .scaleAspectFit)
    
    private lazy var locationView: UIView = {
        let view = UIView()
        view.addSubview(locationImageView)
        view.addSubview(locationLabel)
        view.autoSetDimension(.height, toSize: 22)
        locationImageView.autoSetDimensions(to: CGSize(width: 20, height: 20))
        locationImageView.autoPinEdge(.leading, to: .leading, of: view)
        locationImageView.autoAlignAxis(.horizontal, toSameAxisOf: view)
        locationLabel.autoAlignAxis(.horizontal, toSameAxisOf: locationImageView)
        locationLabel.autoPinEdge(.leading, to: .trailing, of: locationImageView, withOffset: 5)
        locationLabel.autoPinEdge(.trailing, to: .trailing, of: view)
        return view
    }()
    
    private lazy var headlineLabel = UILabel(numberOfLines: 2)
    
    private lazy var infoStackView = UIStackView(arrangedSubviews: [industryLabel,
                                                                    nameLabel,
                                                                    locationView],
                                                 axis: .vertical,
                                                 distribution: .equalSpacing,
                                                 alignment: .fill,
                                                 spacing: 3)
    
    private lazy var miniStackView = UIStackView(arrangedSubviews: [imageView, infoStackView],
                                                 axis: .horizontal,
                                                 distribution: .fill,
                                                 alignment: .top,
                                                 spacing: 16)
    
    private lazy var mainStackView = UIStackView(arrangedSubviews: [miniStackView,
                                                                    headlineLabel,
                                                                    UIView.dividerView(height: 4)],
                                                 axis: .vertical,
                                                 distribution: .equalSpacing,
                                                 alignment: .fill,
                                                 spacing: 8)

    private lazy var superMatchView = SuperMatchView(theme: theme)
    
    private lazy var superMatchShimmerView: FBShimmeringView = {
        let view = FBShimmeringView()
        view.contentView = superMatchView
        superMatchView.autoPinEdgesToSuperviewEdges()
        view.isShimmering = false
        return view
    }()
    
    // MARK: - Constants

    private static let imageWidth: CGFloat = 80
    private static let labelHeight: CGFloat = 16
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets the view with given member information.
    ///
    /// - Parameter memberInfo: Member information object.
    func setup(memberInfo: MemberInfo?, isLoading: Bool) {
        setupMember(with: memberInfo)
        setupView(for: isLoading)
    }
    
    /// Cancels any ongoing image requests.
    func cancelImageRequest() {
        imageView.af_cancelImageRequest()
        imageView.image = #imageLiteral(resourceName: "avatar")
    }
    
}

// MARK: - Private Functions
private extension MemberMatchCellView {
    
    func setupDesign() {
        backgroundColor = colorTheme.invertTertiary
        superMatchView.matchViewColor = colorTheme.invertPrimary

        layer.borderColor = colorTheme.emphasisSecondary.cgColor
        layer.borderWidth = 1
        layer.applySketchShadow(color: UIColor(hexString: "#C5A395").withAlphaComponent(0.3), shawdowY: 7, blur: 16)

        addSubview(mainStackView)
        addSubview(superMatchShimmerView)
        mainStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 24, right: 24), excludingEdge: .bottom)
        superMatchShimmerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        mainStackView.autoPinEdge(.bottom, to: .top, of: superMatchShimmerView)
        setupDefaultHeights()
    }

    func setupDefaultHeights() {
        locationLabel.autoSetDimension(.height, toSize: MemberMatchCellView.labelHeight, relation: .greaterThanOrEqual)
        industryLabel.autoSetDimension(.height, toSize: MemberMatchCellView.labelHeight, relation: .greaterThanOrEqual)
        headlineLabel.autoSetDimension(.height, toSize: MemberMatchCellView.labelHeight, relation: .greaterThanOrEqual)
        nameLabel.autoSetDimension(.height, toSize: MemberMatchCellView.labelHeight, relation: .greaterThanOrEqual)
    }

    func setupMember(with memberInfo: MemberInfo?) {
        guard let memberInfo = memberInfo else {
            return
        }

        setImage(memberInfo.imageURL)
        setIndustry(memberInfo.industry?.name)
        nameLabel.setMarkdownText("**\(memberInfo.name)**",
            using: textStyleTheme.bodyLarge.withColor(colorTheme.emphasisQuintary).withLineBreakMode(.byTruncatingTail))
        setLocation(memberInfo.homebase?.name)
        setHeadline(memberInfo.headline)
        superMatchView.setup(description: memberInfo.superMatchDescription)
    }

    func setupView(for isLoading: Bool) {
        if isLoading {
            locationView.isHidden = false
            headlineLabel.isHidden = false
            industryLabel.isHidden = false
        }

        startShimmer(isLoading)
        superMatchShimmerView.isShimmering = isLoading
        superMatchView.isLoading = isLoading
        layer.borderColor = isLoading ? colorTheme.tertiary.cgColor : colorTheme.emphasisSecondary.cgColor
    }
    
    func setImage(_ url: URL?) {
        guard let url = url else {
            return
        }
        
        imageView.loadImage(from: url)
    }
    
    func setIndustry(_ industry: String?) {
        guard let industry = industry, !industry.isEmpty else {
            industryLabel.isHidden = true
            return
        }
        
        industryLabel.accessibilityLabel = industry
        let textStyle = textStyleTheme.captionNormal.withColor(colorTheme.emphasisSecondary)
        industryLabel.setMarkdownText("**\(industry.uppercased())**", using: textStyle.withLineBreakMode(.byTruncatingTail))
        industryLabel.isHidden = false
    }
    
    func setLocation(_ location: String?) {
        guard let location = location, !location.isEmpty else {
            locationView.isHidden = true
            return
        }
        
        let textStyle = textStyleTheme.subheadlineLarge.withColor(colorTheme.emphasisQuaternaryMuted)
        locationLabel.setText(location, using: textStyle.withLineBreakMode(.byTruncatingTail))
        locationView.isHidden = false
    }
    
    func setHeadline(_ headline: String?) {
        guard let headline = headline, !headline.isEmpty else {
            headlineLabel.isHidden = true
            return
        }
        
        headlineLabel.setText(headline, using: textStyleTheme.subheadlineLarge.withLineBreakMode(.byTruncatingTail))
        headlineLabel.isHidden = false
    }
    
}

// MARK: - ShimmerProtocol
extension MemberMatchCellView: ShimmerProtocol {

    var shimmerViews: [ShimmerView] {
        return [ShimmerView(industryLabel, style: .short, height: 9),
                ShimmerView(nameLabel, style: .long, height: 13),
                ShimmerView(locationLabel, style: .medium, height: 7),
                ShimmerView(headlineLabel, style: .multi(sections: 2, spacing: 6), height: 13)]
    }

    var shimmerImageViews: [ShimmerImageView] {
        return [ShimmerImageView(imageView), ShimmerImageView(locationImageView, image: #imageLiteral(resourceName: "homebase_icon"), shimmerImage: #imageLiteral(resourceName: "loading_dot"))]
    }

    var ignoredFBShimmerViews: [UIView] {
        return [superMatchShimmerView]
    }

}
