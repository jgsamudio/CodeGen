//
//  AttendeeCellView.swift
//  TheWing
//
//  Created by Luna An on 8/22/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class AttendeeCellView: BuildableView {
    
    // MARK: - Public Properties
    
    /// Event Detail attendee cell view delegate.
    weak var delegate: AttendeeCellViewDelegate?
    
    // MARK: - Private Properties
    
    private var memberInfo: MemberInfo?

    private lazy var memberInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, headlineLabel, industryLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "avatar"))
        imageView.contentMode = .scaleAspectFill
        imageView.autoSetDimensions(to: CGSize(width: imageSize, height: imageSize))
        imageView.layer.cornerRadius = 27
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var lineSeparatorView = UIView.dividerView(height: ViewConstants.lineSeparatorThickness,
                                                            color: colorTheme.tertiary)

    private lazy var nameLabel = UILabel(numberOfLines: 0)
    private lazy var headlineLabel = UILabel(numberOfLines: 0)
    private lazy var industryLabel = UILabel(numberOfLines: 0)
 
    // MARK: - Constants
    
    private let imageSize: CGFloat = 54
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellSelected)))
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets the view with member info passed.
    ///
    /// - Parameter memberInfo: Member info for the cell.
    func setup(memberInfo: MemberInfo) {
        self.memberInfo = memberInfo
        setNameLabel(name: memberInfo.name)
        setHeadlineLabel(headline: memberInfo.headline)
        setIndustryLabel(industry: memberInfo.industry?.name)
        setImage(url: memberInfo.imageURL)
    }
    
    /// Cancels network request to load image.
    func cancelImageRequest() {
        imageView.af_cancelImageRequest()
    }
    
}

// MARK: - Private Functions
private extension AttendeeCellView {
    
    func setupDesign() {
        setupStackView()
        setupImageContaierView()
        setupLineSeparator()
    }
    
    func setupStackView() {
        addSubview(memberInfoStackView)
        memberInfoStackView.autoPinEdge(.top, to: .top, of: self, withOffset: 18)
        memberInfoStackView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 92)
        memberInfoStackView.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -20)
        memberInfoStackView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -18)
    }
    
    func setupImageContaierView() {
        addSubview(imageView)
        imageView.autoAlignAxis(.horizontal, toSameAxisOf: self)
        imageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 20)
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
    
    @objc func cellSelected() {
        guard let memberInfo = memberInfo else {
            return
        }
        delegate?.memberCellSelected(memberInfo: memberInfo)
    }
    
    func setNameLabel(name: String) {
        let attributes = textStyleTheme.headline4.withColor(colorTheme.emphasisQuintary).attributes
        let attributedString = NSMutableAttributedString(string: name, attributes: attributes)
        nameLabel.attributedText = attributedString
    }
    
    func setHeadlineLabel(headline: String?) {
        if let headline = headline, !headline.isEmpty {
            headlineLabel.isHidden = false
            headlineLabel.setText(headline, using: textStyleTheme.bodySmall)
        } else {
            headlineLabel.isHidden = true
        }
    }
    
    func setIndustryLabel(industry: String?) {
        guard let industry = industry, !industry.isEmpty else {
            industryLabel.text = " "
            return
        }
        let textStyle = textStyleTheme.captionNormal.withColor(colorTheme.emphasisSecondary).withStrongFont()
        industryLabel.setText(industry.uppercased(), using: textStyle)
    }
    
}
