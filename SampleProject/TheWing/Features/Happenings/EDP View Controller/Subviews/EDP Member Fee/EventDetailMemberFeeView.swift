//
//  EventDetailMemberFeeView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EventDetailMemberFeeView: BuildableView {

    // MARK: - Public Properties

    weak var delegate: EventDetailMemberFeeDelegate?

    // MARK: - Private Properties

    private var label = UILabel()

    private lazy var infoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "info_button"))
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = "ACCESSIBILITY_INFORMATION_ICON_TITLE".localized(comment: "Information icon title")
        imageView.accessibilityTraits = UIAccessibilityTraitButton
        imageView.isHidden = true
        return imageView
    }()

    private lazy var infoTapView: UIView = {
        let view = UIView()
        view.autoSetDimensions(to: CGSize(width: 44, height: 44))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(infoSelected)))
        view.isHidden = true
        return view
    }()
    
    private lazy var shimmerData: [ShimmerData] = {
        let labelSection = [ShimmerSection(width: 92, height: 7)]
        let backgroundColor = theme.colorTheme.emphasisQuaternary.withAlphaComponent(0.1)
        return [ShimmerData(label, sections: labelSection, backgroundColor: backgroundColor)]
    }()
    
    private lazy var shimmerContainer = ShimmerContainer(parentView: self)
    
    // MARK: - Initialization

    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Configures view with given member types.
    ///
    /// - Parameter types: Event member types.
    func set(types: [EventMemberType]) {
        updateInfoImage(types: types)
        label.setMarkdownText(EventMemberType.memberInfo(types: types),
                              using: theme.textStyleTheme.captionBig.withCharacterSpacing(1))
    }
    
    /// Sets the view to shimmer.
    ///
    /// - Parameter shimmer: Shimmers, if set to true, false, otherwise.
    func setShimmer(_ shimmer: Bool) {
        shimmerContainer.applyShimmer(enable: shimmer, with: shimmerData)
    }

}

// MARK: - Private Functions
private extension EventDetailMemberFeeView {

    func setupView() {
        backgroundColor = theme.colorTheme.invertTertiary
        clipsToBounds = false
        setupLabelView()
        setupInfoImageView()
    }

    func setupLabelView() {
        addSubview(label)
        let insets = UIEdgeInsets(top: 0, left: ViewConstants.defaultGutter, bottom: 0, right: 0)
        label.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .trailing)
        label.autoSetDimension(.height, toSize: 16)
    }

    func setupInfoImageView() {
        addSubview(infoImageView)
        infoImageView.autoAlignAxis(.horizontal, toSameAxisOf: label)
        infoImageView.autoPinEdge(.leading, to: .trailing, of: label, withOffset: 8)

        addSubview(infoTapView)
        infoTapView.autoAlignAxis(.horizontal, toSameAxisOf: self)
        infoTapView.autoAlignAxis(.vertical, toSameAxisOf: infoImageView)
    }

    func updateInfoImage(types: [EventMemberType]) {
        let feeTypes = types.filter { (type) -> Bool in
            switch type {
            case .fee:
                return true
            default:
                return false
            }
        }
        
        guard feeTypes.first != nil else {
            infoImageView.isHidden = true
            infoTapView.isHidden = true
            return
        }
        
        infoImageView.isHidden = false
        infoTapView.isHidden = false
    }

    @objc func infoSelected() {
        delegate?.infoSelected()
    }

}
