//
//  EventDetailViewController.swift
//  TheWing
//
//  Created by Luna An on 4/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Pilas
import Velar

final class EventDetailViewController: BuildableViewController {
    
    // MARK: - Public Properties
    
    /// View model.
    var viewModel: EventDetailViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var navigationView: TransitioningNavigationView = {
        let barButtons = [bookmarkButton, shareButton]
        let navigationView = TransitioningNavigationView(theme: theme, backButton: backButton, barButtons: barButtons)
        navigationView.transitionColor = theme.colorTheme.invertPrimary
        return navigationView
    }()
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "black_back_button"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonSelected), for: .touchUpInside)
        backButton.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        return backButton
    }()
    
    private lazy var shareButton: UIButton = {
        let shareButton = UIButton()
        shareButton.setImage(#imageLiteral(resourceName: "share_button"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonSelected), for: .touchUpInside)
        shareButton.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        return shareButton
    }()
    
    private lazy var bookmarkButton: BookmarkButton = {
        let bookmarkButton = BookmarkButton()
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonSelected), for: .touchUpInside)
        bookmarkButton.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        return bookmarkButton
    }()
    
    private lazy var calendarPermissionsValidator: CalendarPermissionsValidator = {
        let validator = CalendarPermissionsValidator()
        validator.delegate = self
        return validator
    }()
    
    private lazy var eventModalActionRouter: EventModalActionRouter = {
        let actionRouter = EventModalActionRouter(velarPresenter: velarPresenter, viewController: self)
        actionRouter.delegate = viewModel
        return actionRouter
    }()
    
    private lazy var header = EventDetailHeaderView(theme: theme)
    
    private lazy var buttonView = EventDetailButtonView(theme: theme, delegate: self)
    
    private lazy var feeModal = EventModal(theme: theme, type: .feeExplanation, delegate: eventModalActionRouter)
    
    private var eventModal: EventModal?
    
    private lazy var memberFeeView: EventDetailMemberFeeView = {
        let view = EventDetailMemberFeeView(theme: theme)
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    private lazy var dateLocationView: EventDetailDateLocationInfoView = {
        let view = EventDetailDateLocationInfoView(theme: theme)
        view.delegate = self
        return view
    }()
    
    private lazy var descriptionContainerView: UIView = {
        let view = UIView()
        view.addSubview(descriptionLabel)
        view.backgroundColor = theme.colorTheme.invertTertiary
        descriptionLabel.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets)
        view.isHidden = true
        return view
    }()
    
    private lazy var shimmerDescriptionView: UIView = {
        let subview = UIView()
        subview.backgroundColor = colorTheme.invertTertiary
        subview.addSubview(shimmerStackView)
        shimmerStackView.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets)
        subview.isHidden = true
        return subview
    }()
    
    private lazy var shimmerData: [ShimmerData] = {
        let backgroundColor = theme.colorTheme.emphasisQuaternary.withAlphaComponent(0.1)
        let totalWidth = UIScreen.width - (3 * ViewConstants.defaultGutter)
        return shimmerStackView.arrangedSubviews.map {
            ShimmerData($0, sections: ShimmerSection.generate(minWidth: 44,
                                                              height: 7,
                                                              totalWidth: totalWidth,
                                                              maxNumberOfSections: 4),
                        backgroundColor: backgroundColor)
        }
    }()
    
    private lazy var shimmerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [],
                                    axis: .vertical,
                                    distribution: .fill,
                                    alignment: .leading,
                                    spacing: 14)
        for _ in 0..<8 {
            let view = UIView()
            view.autoSetDimension(.height, toSize: 7)
            stackView.addArrangedSubview(view)
        }
        return stackView
    }()
    
    private lazy var shimmerContainer = ShimmerContainer(parentView: shimmerDescriptionView)
    
    private lazy var descriptionLabel = UILabel(numberOfLines: 0)
    
    private lazy var attendeeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = colorTheme.invertTertiary
        view.addSubview(attendeesHeaderView)
        view.isHidden = true
        
        let insets = UIEdgeInsets(top: 24, left: ViewConstants.defaultGutter, bottom: 0, right: ViewConstants.defaultGutter)
        attendeesHeaderView.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
        
        view.addSubview(membersStackView)
        membersStackView.autoPinEdge(toSuperviewEdge: .leading)
        membersStackView.autoPinEdge(toSuperviewEdge: .trailing)
        membersStackView.autoPinEdge(.top, to: .bottom, of: attendeesHeaderView, withOffset: 16)
        
        view.addSubview(seeAllButton)
        seeAllButton.autoPinEdge(.top, to: .bottom, of: membersStackView, withOffset: 40)
        seeAllButton.autoPinEdge(toSuperviewEdge: .bottom)
        return view
    }()
    
    private lazy var attendeesHeaderView = SectionHeaderActionView(theme: theme)
    
    private lazy var membersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var seeAllButton: UIButton = {
        let button = StylizedButton(buttonStyle: theme.buttonStyleTheme.tertiaryButtonStyle)
        button.autoSetDimensions(to: CGSize(width: 120, height: 32))
        button.setTitle("SEE_ALL".localized(comment: "See All").uppercased(), for: .normal)
        button.addTarget(self, action: #selector(openAllAttendees), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var scrollView: PilasScrollView = {
        let scrollView = PilasScrollView()
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.autoPinEdgesToSuperviewEdges(excludingEdge: .top)
        return scrollView
    }()
    
    private lazy var refreshView: RefreshControlView = {
        let controlView = RefreshControlView(indicatorColor: colorTheme.primary)
        controlView.backgroundColor = theme.colorTheme.invertPrimary
        let textStyle = textStyleTheme.captionNormal.withColor(colorTheme.emphasisSecondary)
        controlView.refreshLabel.setMarkdownText("**\(HomeLocalization.pullToRefreshTitle.uppercased())**", using: textStyle)
        controlView.bottomImageView.image = #imageLiteral(resourceName: "separator_icon")
        controlView.delegate = self
        return controlView
    }()
    
    private lazy var velarPresenter: VelarPresenter = {
        return VelarPresenterBuilder.build(designer: DefaultBackgroundOverlayDesigner(theme: theme))
    }()
    
    private var buttonBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        viewModel.loadPrefetchedData()
        viewModel.loadEvent()
    }
    
}

// MARK: - Private Functions
private extension EventDetailViewController {
    
    func setupDesign() {
        view.backgroundColor = theme.colorTheme.invertPrimary
        setupScrollView()
        setupNavigationView()
        setupButtonView()
        updateContentInset()
        setupRefreshControl()
        scrollView.autoPinEdge(.top, to: .bottom, of: navigationView)
    }
    
    func setupRefreshControl() {
        view.insertSubview(refreshView, belowSubview: scrollView)
        refreshView.autoPinEdge(.top, to: .bottom, of: navigationView)
        refreshView.autoPinEdge(.leading, to: .leading, of: view)
        refreshView.autoPinEdge(.trailing, to: .trailing, of: view)
    }
    
    func setupScrollView() {
        scrollView.insertView(view: header)
        scrollView.insertView(view: dateLocationView)
        scrollView.insertDividerView(height: 14, backgroundColor: theme.colorTheme.invertTertiary)
        scrollView.insertView(view: memberFeeView)
        scrollView.insertDividerView(height: 24, backgroundColor: theme.colorTheme.invertTertiary)
        scrollView.insertView(view: shimmerDescriptionView)
        scrollView.insertView(view: descriptionContainerView)
        scrollView.insertView(view: attendeeContainerView)
        scrollView.insertDividerView(height: 56, backgroundColor: theme.colorTheme.invertTertiary)
    }
    
    func setupNavigationView() {
        view.insertSubview(navigationView, aboveSubview: scrollView)
        navigationView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
    }
    
    func setupButtonView() {
        view.insertSubview(buttonView, aboveSubview: scrollView)
        let height = ViewConstants.bottomButtonHeight
        buttonView.autoSetDimension(.height, toSize: height)
        buttonBottomConstraint = buttonView.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: height)
        buttonView.autoPinEdge(.leading, to: .leading, of: view)
        buttonView.autoPinEdge(.trailing, to: .trailing, of: view)
    }
    
    func updateContentInset() {
        view.layoutIfNeeded()
        let bottomInset = buttonView.frame.height
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        scrollView.scrollIndicatorInsets = insets
        scrollView.contentInset = insets
    }
    
    func showButtonView() {
        if let constraint = buttonBottomConstraint, constraint.constant > CGFloat(0) {
            buttonBottomConstraint?.constant = 0.0
            UIView.animate(withDuration: AnimationConstants.fastAnimationDuration,
                           delay: AnimationConstants.defaultAnimationDelay,
                           options: .curveEaseOut,
                           animations: {
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func configureAttendeesHeader(text: String?) {
        if let header = text {
            attendeesHeaderView.setup(title: header,
                                      buttonTitle: "SEE_ALL".localized(comment: "See All"),
                                      target: self,
                                      selector: #selector(openAllAttendees))
            seeAllButton.autoAlignAxis(toSuperviewAxis: .vertical)
        }
    }
    
    func configureMembers(_ members: [MemberInfo]) {
        membersStackView.removeAllArrangedSubviews()
        members.forEach {
            let cellView = AttendeeCellView(theme: theme)
            cellView.delegate = self
            cellView.setup(memberInfo: $0)
            membersStackView.addArrangedSubview(cellView)
        }
    }
    
    @objc func openAllAttendees() {
        let viewController = builder.attendeesViewController(eventId: viewModel.eventId, title: viewModel.allAttendeesTitle)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func backButtonSelected() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonSelected() {
        viewModel.shareEvent()
    }
    
    @objc func bookmarkButtonSelected() {
        if viewModel.toggleBookmarkStatus() {
            showSnackBar(with: SnackBarLocalization.bookmarkAdded, dismissAfter: 3)
        }
    }
    
}

// MARK: - RefreshControlDelegate
extension EventDetailViewController: RefreshControlDelegate {
    
    func reload() {
        setInitialLoad(true)
        viewModel.loadEvent()
    }
    
}

// MARK: - EventDetailViewDelegate
extension EventDetailViewController: EventDetailViewDelegate {
    
    func attemptToPresentPushPermission() {
        presentPushPermissionAlertIfNeeded()
    }
    
    func setInitialLoad(_ initialLoad: Bool) {
        view.isUserInteractionEnabled = !initialLoad
        header.setInitialLoad(initialLoad)
        dateLocationView.setShimmer(initialLoad)
        memberFeeView.setShimmer(initialLoad)
        memberFeeView.isHidden = !initialLoad
        shimmerContainer.applyShimmer(enable: initialLoad, with: shimmerData)
        shimmerDescriptionView.isHidden = !initialLoad
        attendeesHeaderView.startShimmer(initialLoad)
        attendeeContainerView.isHidden = !initialLoad
    }
    
    func isLoading(_ loading: Bool) {
        bookmarkButton.isUserInteractionEnabled = !loading
        shareButton.isUserInteractionEnabled = !loading
        header.isLoading(loading)
        refreshView.setIsLoading(loading, scrollView: scrollView)
    }
    
    func displayDescription(_ text: String) {
        descriptionContainerView.isHidden = false
        descriptionLabel.setText(text, using: theme.textStyleTheme.bodyNormal)
    }
    
    func displayHeader(title: String, headline: String) {
        header.setup(title: title, headline: headline)
    }
    
    func displayBadge(_ badge: EventBadgeType) {
        header.setIcon(with: badge.image)
    }
    
    func displayTopicIcon(from imageURL: URL) {
        header.setIcon(with: imageURL)
    }
    
    func displayButtons(statusTypes: [EventActionButtonSource]) {
        buttonView.statusTypes = statusTypes
        updateContentInset()
        showButtonView()
    }
    
    func displayDate(date: String, time: String, location: String, address: String) {
        dateLocationView.setup(date: date, time: time, location: location, address: address)
    }
    
    func displayMemberInfo(types: [EventMemberType]) {
        memberFeeView.isHidden = (types.count == 0)
        memberFeeView.set(types: types)
    }
    
    func shareEvent(with data: EventData, message: String) {
        analyticsProvider.track(event: AnalyticsEvents.Happenings.shareEvent.analyticsIdentifier,
                                properties: data.analyticsProperties(forScreen: self),
                                options: nil)
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
    
    func button(loading: Bool, type: EventActionButtonSource) {
        buttonView.isLoading(loading: loading, type: type)
    }
    
    func displayEventModal(with data: EventModalData) {
        let eventModal = EventModal(theme: theme,
                                    type: data.type,
                                    delegate: eventModalActionRouter,
                                    calendarViewDelegate: self)
        
        eventModal.setup(eventData: data)
        velarPresenter.show(view: eventModal, animate: true)
    }
    
    func displayFeeModal(with data: EventModalData) {
        feeModal.setup(eventData: data)
        velarPresenter.show(view: feeModal, animate: true)
    }
    
    func setAttendees(show: Bool, attendees: [MemberInfo], headerText: String?) {
        attendeeContainerView.isHidden = !show
        membersStackView.isHidden = !show
        seeAllButton.isHidden = !show
        configureAttendeesHeader(text: headerText)
        configureMembers(attendees)
    }
    
    func addGuestSelected(eventData: EventData) {
        analyticsProvider.track(event: AnalyticsEvents.Happenings.editGuests.analyticsIdentifier,
                                properties: eventData.analyticsProperties(forScreen: self),
                                options: nil)
        eventModalActionRouter.addGuestSelected(eventData: eventData)
    }
    
    func updateBookmark(bookmarkInfo: BookmarkInfo) {
        bookmarkButton.set(bookmarkInfo: bookmarkInfo)
    }
    
    func showBookmark(show: Bool) {
        bookmarkButton.isHidden = !show
    }
    
}

// MARK: - AttendeeCellViewDelegate
extension EventDetailViewController: AttendeeCellViewDelegate {
    
    func memberCellSelected(memberInfo: MemberInfo) {
        if let currentUser = currentUser, currentUser.userId == memberInfo.userId {
            let analyticsProperties = currentUser.analyticsProperties(forScreen: self, andAdditionalProperties: [
                AnalyticsConstants.ProfileCTA.key: AnalyticsConstants.ProfileCTA.memberCell.analyticsIdentifier
                ])
            analyticsProvider.track(event: AnalyticsEvents.Profile.profileClicked.analyticsIdentifier,
                                    properties: analyticsProperties,
                                    options: nil)
        } else {
            let analyticsProperties = memberInfo.analyticsProperties(forScreen: self, andAdditionalProperties: [
                AnalyticsConstants.ProfileCTA.key: AnalyticsConstants.ProfileCTA.memberCell.analyticsIdentifier
                ])
            analyticsProvider.track(event: AnalyticsEvents.Community.didSelectProfile.analyticsIdentifier,
                                    properties: analyticsProperties,
                                    options: nil)
        }
        
        let viewController = builder.profileViewController(userId: memberInfo.userId, partialMemberInfo: memberInfo)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - UIScrollViewDelegate
extension EventDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        let percent = navigationView.transitionPercentageWith(offset: yOffset)
        navigationView.transition(percent: percent)
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshView.scrollViewDidEndDragging(scrollView)
    }
    
}

// MARK: - DateLocationInfoViewDelegate
extension EventDetailViewController: DateLocationInfoViewDelegate {
    
    func addToCalendarSelected() {
        guard let eventCalendarInfo = viewModel.calendarInfo else {
            return
        }
        analyticsProvider.track(event: AnalyticsEvents.Happenings.addedToCalendar.analyticsIdentifier,
                                properties: viewModel.analyticsProperties(forScreen: self),
                                options: nil)
        calendarPermissionsValidator.addEventToCalendar(eventInfo: eventCalendarInfo)
    }
    
    func addressSelected() {
        guard let addressString = viewModel.addressString else {
            return
        }
        
        presentAddressActionSheet(addressString: addressString)
    }
    
}

// MARK: - EventDetailMemberFeeDelegate
extension EventDetailViewController: EventDetailMemberFeeDelegate {
    
    func infoSelected() {
        viewModel.displayFeeInformation()
    }
    
}

// MARK: - EventDetailButtonDelegate
extension EventDetailViewController: EventDetailButtonDelegate {
    
    func buttonSelected(status: EventActionButtonSource) {
        viewModel.updateEvent(status: status)
    }
    
}

// MARK: - AnalyticsIdentifiable
extension EventDetailViewController: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.eventDetail.analyticsIdentifier
    }
    
}
