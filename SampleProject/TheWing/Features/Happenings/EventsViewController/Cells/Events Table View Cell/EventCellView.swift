//
//  EventCellView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EventCellView: BuildableView {
    
    // MARK: - Public Properties
    
    weak var delegate: EventCellDelegate?

    private(set) var data: EventData?
    
    // MARK: - Private Properties

    private var showFormat: Bool {
        return options.showFormat
    }
    
    private var options: EventCellViewOptions
    private var modalType: EventModalType?

    private var headlineLabel = UILabel()
    private var titleLabel = UILabel()
    private var dateLabel = UILabel()
    private var timeLabel = UILabel()
    private var locationLabel = UILabel()
    private var leftImageView = UIImageView()
    private var bookmarkButton = BookmarkButton()
    private var rightImageView = UIImageView()
    private var detailLabel = UILabel()
    
    private var separatorHeightConstraint: NSLayoutConstraint?

    private lazy var shimmerContainer = ShimmerContainer(parentView: self)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var shimmerData: [ShimmerData] = {
        let defaultHeight: CGFloat = 7
        let defaultWidth: CGFloat = 39
        let defaultTotalWidth: CGFloat = 85

        let titleSections = ShimmerSection.generate(minWidth: 26, height: 13, totalWidth: 229, maxNumberOfSections: 3)
        let headlineSections = ShimmerSection.generate(minWidth: 16,
                                                       height: defaultHeight,
                                                       totalWidth: 104,
                                                       maxNumberOfSections: 3)
        let timeSections = ShimmerSection.generate(minWidth: defaultWidth,
                                                   height: defaultHeight,
                                                   totalWidth: defaultTotalWidth,
                                                   maxNumberOfSections: 2)
        let locationSections = ShimmerSection.generate(minWidth: defaultWidth,
                                                       height: defaultHeight,
                                                       totalWidth: defaultTotalWidth,
                                                       maxNumberOfSections: 2)
        let backgroundColor = theme.colorTheme.emphasisQuaternary.withAlphaComponent(0.1)

        return [ShimmerData(headlineLabel, sections: headlineSections, backgroundColor: backgroundColor),
                ShimmerData(titleLabel, sections: titleSections, backgroundColor: backgroundColor),
                ShimmerData(timeLabel, sections: timeSections, backgroundColor: backgroundColor),
                ShimmerData(locationLabel, sections: locationSections, backgroundColor: backgroundColor),
                ShimmerData(leftImageView, matchViewDimensions: true, image: #imageLiteral(resourceName: "loading_wing_icon"), backgroundColor: backgroundColor),
                ShimmerData(bookmarkButton, matchViewDimensions: true, image: #imageLiteral(resourceName: "loading_bookmarked_button"), backgroundColor: backgroundColor),
                ShimmerData(actionButton, matchViewDimensions: true, backgroundColor: backgroundColor)]
    }()

    private lazy var actionContainer: UIView = {
        let view = UIView()
        view.addSubview(actionButton)
        view.addSubview(lockedButton)
        actionButton.autoAlignAxis(.horizontal, toSameAxisOf: view)
        actionButton.autoPinEdge(.trailing, to: .trailing, of: view)
        lockedButton.autoAlignAxis(.horizontal, toSameAxisOf: view)
        lockedButton.autoPinEdge(.trailing, to: .trailing, of: view)
        view.autoSetDimensions(to: CGSize(width: 122, height: 44))
        actionButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionContainerSelected)))
        lockedButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionContainerSelected)))
        view.isHidden = true
        view.isAccessibilityElement = true
        view.accessibilityTraits = UIAccessibilityTraitButton
        return view
    }()
    
    private lazy var actionButton: StylizedButton = {
        let button = StylizedButton(buttonStyle: theme.buttonStyleTheme.smallCancelButtonStyle)
        button.autoSetDimensions(to: CGSize(width: 80, height: 26))
        button.isHidden = true
        return button
    }()
    
    private lazy var lockedButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "locked_small"), for: .normal)
        button.autoSetDimensions(to: CGSize(width: 16, height: 24))
        button.isHidden = true
        return button
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.colorTheme.secondary
        view.addSubview(separatorBorder)
        separatorBorder.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        return view
    }()

    private lazy var separatorBorder = UIView.dividerView(height: 1, color: theme.colorTheme.secondary)
    
    // MARK: - Constants
    
    fileprivate static let labelOffset: CGFloat = 10
    fileprivate static let separatorHeight: CGFloat = 7
    fileprivate static let separatorTopSpacing: CGFloat = 18
    fileprivate static let defaultLabelHeight: CGFloat = 16
    fileprivate static let trailingOffset: CGFloat = -24
    fileprivate static let bottomOffset: CGFloat = 6
    
    // MARK: - Initialization
    
    init(theme: Theme, options: EventCellViewOptions) {
        self.options = options
        super.init(theme: theme)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Sets up event cell view with data.
    ///
    /// - Parameters:
    ///   - data: Optional event data.
    ///   - modalType: Type of modal to show.
    ///   - options: Cell view options.
    ///   - isLoading: Flag to determine if the view is loading.
    func setup(data: EventData?,
               modalType: EventModalType? = nil,
               options: EventCellViewOptions? = nil,
               isLoading: Bool = false) {
        self.data = data
        self.modalType = modalType

        if let options = options {
            self.options = options
        }

        updateLoadingState(isLoading: isLoading, data: data)

        guard let data = data else {
            return
        }

        let format = showFormat && data.format != nil ? "\(ViewConstants.dot)\(data.format!.capitalized)" : ""
        let headline = "\(data.topic.uppercased())\(format)"
        headlineLabel.setText(headline, using: theme.textStyleTheme.subheadlineBig.withCharacterSpacing(1))

        let titleTextStyle = theme.textStyleTheme.headline4.withColor(theme.colorTheme.emphasisQuintary)
        titleLabel.setText(data.title, using: titleTextStyle)

        let infoTextStyle = theme.textStyleTheme.captionBig.withCharacterSpacing(1)
        timeLabel.setText(data.time, using: infoTextStyle)
        locationLabel.setMarkdownText("*\(data.locationName.uppercased())*", using: infoTextStyle)

        updateBookmarkButton(data.bookmarkInfo)
        updateForAction(data.quickAction, infoDetail: data.infoDetail)
        updateDateLabel()
        updateLeftImage()
        updateRightImageIfNeeded()
    }
    
    /// Hides headline view.
    func hideHeadlineView() {
        headlineLabel.isHidden = true
    }
    
    /// Hides separator view.
    func hideSeperatorView() {
        separatorView.isHidden = true
    }
    
    /// Cancels image request.
    func cancelImageRequest() {
        leftImageView.af_cancelImageRequest()
    }
    
}

// MARK: - Private Functions
private extension EventCellView {
    
    func updateBookmarkButton(_ bookmarkInfo: BookmarkInfo) {
        if options.showBookmark {
            bookmarkButton.isHidden = false
            bookmarkButton.set(bookmarkInfo: bookmarkInfo)
        } else {
            bookmarkButton.isHidden = true
        }
    }
    
    func updateForAction(_ action: EventActionButtonSource?, infoDetail: String?) {
        guard let action = action else {
            updateInfoDetail(infoDetail)
            return
        }
        
        updateCTA(action)
    }

    func updateLoadingState(isLoading: Bool, data: EventData?) {
        dateLabel.isHidden = !isLoading
        lockedButton.isHidden = !isLoading
        actionContainer.isHidden = isLoading
        rightImageView.isHidden = isLoading
        dateLabel.text = ""
        headlineLabel.text = ""
        titleLabel.text = ""
        locationLabel.text = ""
        timeLabel.text = ""
        shimmerContainer.applyShimmer(enable: isLoading, with: shimmerData)
        updateSeparator(isLoading: isLoading, data: data)
    }
    
    func setupView() {
        setupLeftImageView()
        setupBookmarkButton()
        setupStackView()
        setupRsvpButton()
        setupSeparatorView()
        setupDetailLabel()
        setupRightImageView()
    }
    
    func setupStackView() {
        addSubview(stackView)
        stackView.autoPinEdge(.top, to: .top, of: self, withOffset: 18)
        stackView.autoPinEdge(.leading, to: .trailing, of: leftImageView, withOffset: EventCellView.labelOffset)
        stackView.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: options.trailingOffset)
        setupHeadlineLabel()
        setupTitleLabel()
        stackView.addArrangedSubview(UIView.dividerView(height: 13))
        setupDateLabel()
        setupTimeLabel()
        setupLocationLabel()
    }
    
    func setupLeftImageView() {
        // TEMP until api is ready
        leftImageView.image = #imageLiteral(resourceName: "art_culture")
        leftImageView.contentMode = .scaleAspectFit
        addSubview(leftImageView)
        leftImageView.autoSetDimensions(to: CGSize(width: 40, height: 40))
        leftImageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: EventCellView.labelOffset)
    }
    
    func setupRightImageView() {
        rightImageView.contentMode = .scaleAspectFit
        addSubview(rightImageView)
        rightImageView.autoSetDimensions(to: CGSize(width: 45, height: 45))
        rightImageView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        rightImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        rightImageView.isHidden = true
    }
    
    func setupHeadlineLabel() {
        stackView.addArrangedSubview(headlineLabel)
        headlineLabel.autoSetDimension(.height, toSize: 14)
    }
    
    func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        stackView.addArrangedSubview(UIView.dividerView(height: 8))
        stackView.addArrangedSubview(titleLabel)
        leftImageView.autoAlignAxis(.horizontal, toSameAxisOf: titleLabel)
    }
    
    func setupDateLabel() {
        dateLabel.isHidden = true
        stackView.addArrangedSubview(dateLabel)
        dateLabel.autoSetDimension(.height, toSize: EventCellView.defaultLabelHeight)
    }

    func setupTimeLabel() {
        stackView.addArrangedSubview(timeLabel)
        timeLabel.autoSetDimension(.height, toSize: EventCellView.defaultLabelHeight)
    }
    
    func setupLocationLabel() {
        stackView.addArrangedSubview(UIView.dividerView(height: 2))
        stackView.addArrangedSubview(locationLabel)
        locationLabel.autoSetDimension(.height, toSize: EventCellView.defaultLabelHeight)
    }
    
    func setupBookmarkButton() {
        addSubview(bookmarkButton)
        bookmarkButton.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        bookmarkButton.autoPinEdge(.top, to: .top, of: self, withOffset: 12)
        bookmarkButton.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -7)
        bookmarkButton.isHidden = true
        bookmarkButton.addTarget(self, action: #selector(bookmarkSelected), for: .touchUpInside)
    }
    
    func setupRsvpButton() {
        addSubview(actionContainer)
        actionContainer.autoPinEdge(.bottom, to: .bottom, of: stackView, withOffset: EventCellView.bottomOffset)
        actionContainer.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: EventCellView.trailingOffset)
    }
    
    func setupDetailLabel() {
        addSubview(detailLabel)
        detailLabel.autoPinEdge(.bottom, to: .bottom, of: stackView)
        detailLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: EventCellView.trailingOffset)
        detailLabel.isHidden = true
    }
    
    func setupSeparatorView() {
        addSubview(separatorView)
        separatorView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        let offset = EventCellView.separatorTopSpacing
        separatorView.autoPinEdge(.top, to: .bottom, of: stackView, withOffset: offset)
        separatorHeightConstraint = separatorView.autoSetDimension(.height, toSize: EventCellView.separatorHeight)
    }

    func updateSeparator(isLoading: Bool, data: EventData?) {
        let hideSeparator = data?.isLastEvent ?? false
        let shownSeparatorHeight = isLoading ? 1 : EventCellView.separatorHeight
        separatorHeightConstraint?.constant = hideSeparator ? 0 : shownSeparatorHeight
        
        let loadingBorderColor = theme.colorTheme.emphasisQuintary.withAlphaComponent(0.1)
        let loadingBackgroundColor = isLoading ? loadingBorderColor : theme.colorTheme.secondary
        separatorBorder.backgroundColor = loadingBackgroundColor
        separatorView.backgroundColor = isLoading ? UIColor.clear : loadingBackgroundColor
    }
    
    @objc func actionContainerSelected() {
        guard let data = data else {
            return
        }
        
        delegate?.actionButtonSelected(data: data)
    }
    
    func updateDateLabel() {
        guard let day = data?.day else {
            return
        }
        
        dateLabel.isHidden = !options.showDate
        let infoTextStyle = theme.textStyleTheme.captionBig.withCharacterSpacing(1)
        dateLabel.setText(day, using: infoTextStyle)
    }
    
    func updateLeftImage() {
        if let type = modalType, let badge = type.badge {
            leftImageView.image = badge
        } else if let url = data?.topicIconURL {
            leftImageView.loadImage(from: url)
        } else {
            leftImageView.image = nil
        }
    }

    @objc func bookmarkSelected() {
        delegate?.bookmarkSelected(data: data)
    }
    
    func updateRightImageIfNeeded() {
        guard modalType == nil, let data = data, let badge = EventBadgeType.badgeFor(data) else {
            rightImageView.image = nil
            rightImageView.isHidden = true
            return
        }
        
        rightImageView.image = badge.thumbnailImage
        rightImageView.isHidden = false
        bookmarkButton.isHidden = true
    }
    
    private func updateCTA(_ action: EventActionButtonSource) {
        detailLabel.isHidden = true
        switch action {
        case .rsvp, .waitlist:
            actionButton.setTitle(action.smallButtonTitle?.uppercased(), for: .normal)
            actionButton.buttonStyle = action.smallButtonStyle(buttonStyleTheme: theme.buttonStyleTheme)
            actionButton.isHidden = false
            lockedButton.isHidden = true
            actionContainer.isHidden = !options.showActionButton
        case .locked:
            lockedButton.isHidden = false
            actionButton.isHidden = true
            actionContainer.isHidden = !options.showActionButton
        default:
            actionContainer.isHidden = true
        }
        actionContainer.accessibilityLabel = action.smallButtonTitle
    }
    
    private func updateInfoDetail(_ label: String?) {
        if !options.showActionButton {
            actionContainer.isHidden = true
            detailLabel.isHidden = true
        } else {
            actionContainer.isHidden = (label != nil)
            guard let infoDetail = label else {
                detailLabel.isHidden = true
                return
            }
        
            let textStyle = theme.textStyleTheme.buttonSmallTitleWhiteRegular
            detailLabel.setMarkdownText("*\(infoDetail.uppercased())*",
                using: textStyle.withColor(theme.colorTheme.tertiary))
            detailLabel.isHidden = false
        }
    }
    
}
