//
//  EventDetailDateLocationInfoView.swift
//  TheWing
//
//  Created by Luna An on 4/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EventDetailDateLocationInfoView: BuildableView {
    
    // MARK: - Public Properties
    
    weak var delegate: DateLocationInfoViewDelegate?
    
    // MARK: - Private Properties
    
    private var dateLabel = UILabel()
    
    private var timeLabel = UILabel()
    
    private lazy var locationLabel = UILabel(numberOfLines: 0)
    
    private lazy var addressButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 0
        button.addTarget(self, action: #selector(addressSelected), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView = UIStackView(arrangedSubviews: [dateLabel,
                                                                timeLabel,
                                                                dividerView,
                                                                locationLabel,
                                                                addressButton],
                                             axis: .vertical,
                                             distribution: .fill,
                                             alignment: .leading,
                                             spacing: 2)
    
    private lazy var addToCalendarButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "add_to_calendar"), for: .normal)
        button.addTarget(self, action: #selector(addToCalendarSelected), for: .touchUpInside)
        button.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        return button
    }()
    
    private lazy var dividerView = UIView.dividerView(height: 8, color: .clear)
    
    private lazy var bottomBorderView = UIView.dividerView(height: 1, color: theme.colorTheme.emphasisQuaternaryFaded)
    
    private lazy var shimmerData: [ShimmerData] = {
        let defaultHeight: CGFloat = 7
        let dateSection = [ShimmerSection(width: 166, height: defaultHeight)]
        let timeSection = [ShimmerSection(width: 110, height: defaultHeight)]
        let locationSection = [ShimmerSection(width: 70, height: defaultHeight)]
        let addressSection = [ShimmerSection(width: 153, height: defaultHeight)]
        let bottomBorderSection = [ShimmerSection(width: UIScreen.width - (2 * ViewConstants.defaultGutter), height: 1)]
        let backgroundColor = theme.colorTheme.emphasisQuaternary.withAlphaComponent(0.1)
        
        return [ShimmerData(dateLabel, sections: dateSection, backgroundColor: backgroundColor),
                ShimmerData(timeLabel, sections: timeSection, backgroundColor: backgroundColor),
                ShimmerData(locationLabel, sections: locationSection, backgroundColor: backgroundColor),
                ShimmerData(addressButton, sections: addressSection, backgroundColor: backgroundColor),
                ShimmerData(bottomBorderView, sections: bottomBorderSection, backgroundColor: backgroundColor)]
    }()
    
    private lazy var shimmerContainer = ShimmerContainer(parentView: self)
    
    // MARK: - Constants
    
    private static let gutter: CGFloat = 14
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets up the date and time info with given information.
    ///
    /// - Parameters:
    ///   - date: The date to display.
    ///   - time: The start time to display.
    ///   - location: The location to display.
    ///   - address: The address to display.
    func setup(date: String, time: String, location: String, address: String) {
        let textStyle = theme.textStyleTheme.captionBig.withCharacterSpacing(1)
        dateLabel.setText(date.uppercased(), using: textStyle)
        timeLabel.setText(time.uppercased(), using: textStyle)
        locationLabel.setMarkdownText("*\(location.uppercased())*", using: textStyle)
        addressButton.setTitleText(address, using: textStyle.withColor(theme.colorTheme.emphasisPrimary))
    }
    
    /// Sets the view to shimmer.
    ///
    /// - Parameter shimmer: Shimmers, if set to true, false, otherwise.
    func setShimmer(_ shimmer: Bool) {
        shimmerContainer.applyShimmer(enable: shimmer, with: shimmerData)
    }
    
}

// MARK: - Private Functions
private extension EventDetailDateLocationInfoView {
    
    func setupDesign() {
        backgroundColor = theme.colorTheme.invertTertiary
        setupStackView()
        setupBorderView()
        setupButton()
    }
    
    func setupStackView() {
        addSubview(stackView)
        let insets = UIEdgeInsets(top: EventDetailDateLocationInfoView.gutter,
                                  left: ViewConstants.defaultGutter,
                                  bottom: EventDetailDateLocationInfoView.gutter,
                                  right: ViewConstants.defaultGutter)
        stackView.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
        dateLabel.text = " "
        timeLabel.text = " "
        locationLabel.text = " "
        addressButton.setTitle(" ", for: .normal)
    }
    
    func setupButton() {
        addSubview(addToCalendarButton)
        addToCalendarButton.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -22)
        addToCalendarButton.autoPinEdge(.top, to: .top, of: self, withOffset: 5)
    }
    
    func setupBorderView() {
        addSubview(bottomBorderView)
        bottomBorderView.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets, excludingEdge: .top)
        bottomBorderView.autoPinEdge(.top, to: .bottom, of: stackView, withOffset: 17)
    }
    
    @objc func addToCalendarSelected() {
        delegate?.addToCalendarSelected()
    }
    
    @objc func addressSelected() {
        delegate?.addressSelected()
    }
    
}
