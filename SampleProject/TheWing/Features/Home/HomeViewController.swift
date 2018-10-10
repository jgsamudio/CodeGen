//
//  HomeViewController.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Pilas
import Velar

final class HomeViewController: TabBarItemViewController {
    
	// MARK: - Public Properties

    // MARK: - Public Properties
    
    var viewModel: HomeViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var scrollView: PilasScrollView = {
        let scrollView = PilasScrollView()
        scrollView.alwaysBounceVertical = true

        view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        scrollView.autoPinEdge(.top, to: .bottom, of: headerView)
        scrollView.delegate = self

        view.insertSubview(refreshView, belowSubview: scrollView)
        refreshView.autoPinEdge(.top, to: .bottom, of: headerView)
        refreshView.autoPinEdge(.leading, to: .leading, of: view)
        refreshView.autoPinEdge(.trailing, to: .trailing, of: view)
        return scrollView
    }()

    private lazy var refreshView: RefreshControlView = {
        let controlView = RefreshControlView(indicatorColor: colorTheme.primary)
        controlView.backgroundColor = theme.colorTheme.secondary
        let textStyle = textStyleTheme.captionNormal.withColor(colorTheme.emphasisSecondary)
        controlView.refreshLabel.setMarkdownText("**\(HomeLocalization.pullToRefreshTitle.uppercased())**", using: textStyle)
        controlView.bottomImageView.image = #imageLiteral(resourceName: "separator_icon")
        controlView.delegate = self
        return controlView
    }()
    
    // MARK: - Initialization

    private lazy var initialLoadActivityIndicator: LoadingIndicator = {
        let indicator = LoadingIndicator(activityIndicatorViewStyle: .gray)
        indicator.frame = ViewConstants.loadingIndicatorFooterFrame
        return indicator
    }()

    private lazy var tasksView: CarouselSectionView = {
        let view = CarouselSectionView(theme: theme, headerInsets: UIEdgeInsets(top: 20, left: 24, bottom: 0, right: 24))
        view.registerCell(cellClass: TaskCollectionViewCell.self)
        view.delegate = self
        view.backgroundColor = theme.colorTheme.invertPrimaryMuted
        view.isHidden = true
        return view
    }()
    
    private lazy var happeningsView: HomeHappeningsView = {
        let view = HomeHappeningsView(theme: theme)
        view.eventViewDelegate = self
        view.delegate = self
        view.emptyHappeningsViewDelegate = self
        view.isHidden = true
        return view
    }()

    private lazy var announcementsView: HomeAnnouncementsView = {
        let view = HomeAnnouncementsView(theme: theme, delegate: self)
        view.isHidden = true
        return view
    }()

    private lazy var bookmarkedView: BookmarkedEventsView = {
        let bookmarksView = BookmarkedEventsView(theme: theme)
        bookmarksView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seeAllBookmarksSelected)))
        bookmarksView.isHidden = true
        return bookmarksView
    }()

    private lazy var velarPresenter: VelarPresenter = {
        return VelarPresenterBuilder.build(designer: DefaultBackgroundOverlayDesigner(theme: theme))
    }()

    private lazy var calendarPermissionsValidator: CalendarPermissionsValidator = {
        let validator = CalendarPermissionsValidator()
        validator.delegate = self
        return validator
    }()

    private lazy var eventModalActionRouter: EventModalActionRouter = {
        let actionRouter = EventModalActionRouter(velarPresenter: velarPresenter, viewController: self)
        actionRouter.delegate = viewModel.eventListActionHandler
        return actionRouter
    }()

    private var eventModal: EventModal?
    
    // MARK: - Public Functions

    override func tabBarItemTitle() -> String {
        return HomeLocalization.homeTabTitle
    }
    
    override func tabBarHeaderTitle() -> String {
        return viewModel.title
    }
    
    override func tabBarHeaderSubtitle() -> String? {
        return viewModel.subtitle
    }

    override func tabBarIcon() -> (selected: UIImage?, unselected: UIImage?) {
        return (#imageLiteral(resourceName: "home-active"), #imageLiteral(resourceName: "home-inactive"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        viewModel.loadDashboard()
        scrollView.alpha = 0
        
        NotificationCenter.default.addObserver(viewModel,
                                               selector: #selector(viewModel.loadDashboard),
                                               name: .didUploadAvatar,
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setHeader(title: viewModel.title, subtitle: viewModel.subtitle)
        viewModel.updateMyHappenings()
        viewModel.resyncHomePage()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(viewModel)
    }

}

// MARK: - Private Functions
private extension HomeViewController {
    
    func setupDesign() {
        view.backgroundColor = theme.colorTheme.secondary
        view.addSubview(initialLoadActivityIndicator)
        initialLoadActivityIndicator.isLoading(loading: true)
        initialLoadActivityIndicator.autoCenterInSuperview()
        scrollView.insertView(view: tasksView)
        scrollView.insertView(view: happeningsView)
        scrollView.insertView(view: bookmarkedView)
        scrollView.insertDividerView(height: 40)
        scrollView.insertView(view: announcementsView)
    }
    
    @objc func seeAllBookmarksSelected() {
        let viewController = builder.myHappeningsViewController(type: .bookmarkedHappenings)
        navigationController?.pushViewController(viewController, animated: true)
    }

}

// MARK: - HomeViewDelegate
extension HomeViewController: HomeViewDelegate {
    
    func attemptToPresentPushPermission() {
        presentPushPermissionAlertIfNeeded()
    }

    func openMyBookmarks() {
        seeAllBookmarksSelected()
    }
    
    func openEditProfile() {
        guard let user = viewModel.user else {
            return
        }
        
        let viewController = builder.editProfileViewController(user: user, delegate: viewModel)
        present(viewController, animated: true, completion: nil)
        let analyticsProperties = currentUser?.analyticsProperties(forScreen: self, andAdditionalProperties: [
            AnalyticsConstants.ProfileCTA.key: AnalyticsConstants.ProfileCTA.checklistCard.analyticsIdentifier
        ])
        analyticsProvider.track(event: AnalyticsEvents.Profile.editButtonClicked.analyticsIdentifier,
                                properties: analyticsProperties,
                                options: nil)
    }
    
    func refreshHeader() {
        setHeader(title: viewModel.title, subtitle: viewModel.subtitle)
    }
    
    func displayAnnouncements(data: [AnnouncementData]) {
        announcementsView.dataSources = data
        announcementsView.isHidden = data.isEmpty
    }
    
    func displayBookmarkedEventsView(eventsCount: Int, showEmptyState: Bool) {
        bookmarkedView.setCountLabel(count: eventsCount)
        bookmarkedView.setArrowHidden(showEmptyState)
        bookmarkedView.isUserInteractionEnabled = !showEmptyState
        bookmarkedView.isHidden = false
    }
    
    func updateToDoList(shouldShow: Bool) {
        tasksView.setup(title: HomeLocalization.tasksTitle(with: viewModel.tasks.count),
                        dataSourcesCount: viewModel.tasks.count)
        tasksView.isHidden = !shouldShow
    }

    func displayMyHappenings(eventData: [EventData], totalCount: Int, showEmptyState: Bool) {
        happeningsView.setup(eventData: eventData, totalCount: totalCount, isEmpty: showEmptyState)
        happeningsView.isHidden = false
    }

    func displayEventModal(data: EventModalData) {
        eventModal = EventModal(theme: theme, type: data.type, delegate: eventModalActionRouter, calendarViewDelegate: self)
        if let modal = eventModal {
            modal.setup(eventData: data)
            velarPresenter.show(view: modal, animate: true)
        }
    }

    func addGuestSelected(eventData: EventData) {
        analyticsProvider.track(event: AnalyticsEvents.Happenings.editGuests.analyticsIdentifier,
                                properties: eventData.analyticsProperties(forScreen: self),
                                options: nil)
        eventModalActionRouter.addGuestSelected(eventData: eventData)
    }

    func updateMyHappening(eventData: EventData, remove: Bool, animated: Bool, collapse: Bool) {
        happeningsView.updateMyHappening(eventData: eventData, remove: remove, animated: animated, collapse: collapse)
    }

    func addMyHappening(eventData: EventData) {
        happeningsView.addMyHappening(eventData: eventData)
    }

    func updateTotalHappeningsCount(_ totalCount: Int) {
        happeningsView.totalCount = totalCount
    }

    func isLoading(_ loading: Bool) {
        refreshView.setIsLoading(loading, scrollView: scrollView)
        if !loading {
            UIView.animate(withDuration: AnimationConstants.defaultDuration) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.scrollView.alpha = 1
                strongSelf.initialLoadActivityIndicator.removeFromSuperview()
            }
        }
    }

}

// MARK: - HomeHappeningsDelegate
extension HomeViewController: HomeHappeningsDelegate {

    func seeAllEventsSelected() {
        let viewController = builder.myHappeningsViewController(type: .myHappenings)
        navigationController?.pushViewController(viewController, animated: true)
    }

    func eventSelected(eventData: EventData) {
        let viewController = builder.eventDetailViewController(eventId: eventData.eventId,
                                                               eventData: eventData,
                                                               eventStatusDelegate: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
        analyticsProvider.track(event: AnalyticsEvents.Happenings.cellTapped.analyticsIdentifier,
                                properties: eventData.analyticsProperties(forScreen: self),
                                options: nil)
    }

    func eventRemoved(eventData: EventData) {
        viewModel.eventRemoved(eventData: eventData)
    }

}

// MARK: - EventCellDelegate
extension HomeViewController: EventCellDelegate {

    func actionButtonSelected(data: EventData) {
        viewModel.actionButtonSelected(with: data)
    }

}

// MARK: - AddToCalendarViewDelegate
extension HomeViewController: AddToCalendarViewDelegate {

    func addToCalendarSelected() {
        guard let eventCalendarInfo = viewModel.eventListActionHandler.selectedEventCellData?.eventCalendarInfo else {
            return
        }
        let properties = viewModel.eventListActionHandler.selectedEventCellData?.analyticsProperties(forScreen: self)
        analyticsProvider.track(event: AnalyticsEvents.Happenings.addedToCalendar.analyticsIdentifier,
                                properties: properties,
                                options: nil)
        calendarPermissionsValidator.addEventToCalendar(eventInfo: eventCalendarInfo)
    }

}

// MARK: - HomeAnnouncementsViewDelegate
extension HomeViewController: HomeAnnouncementsViewDelegate {

    func didSelectItemAt(_ indexPath: IndexPath) {
        if indexPath.row < viewModel.announcements.count {
            let viewController = builder.announcementViewController(announcement: viewModel.announcements[indexPath.row])
            present(viewController, animated: true, completion: nil)
        }
    }

}

// MARK: - EmptyMyHappeningsViewDelegate
extension HomeViewController: EmptyMyHappeningsViewDelegate {
    
    func actionButtonSelected() {
        tabBarController?.selectedIndex = TabDestination.happenings.rawValue
    }
    
}

// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshView.scrollViewDidEndDragging(scrollView)
    }

}

// MARK: - RefreshControlDelegate
extension HomeViewController: RefreshControlDelegate {

    func reload() {
        viewModel.reloadUser()
        viewModel.loadDashboard()
    }

}

// MARK: - CarouselSectionViewDelegate
extension HomeViewController: CarouselSectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TaskCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let task = viewModel.tasks[indexPath.row]
        let options = TaskCellViewOptions(title: task.title,
                                          description: task.description,
                                          buttonTitle: task.buttonTitle,
                                          buttonStyle: task.type.buttonStyle(buttonStyleTheme: buttonStyleTheme),
                                          isFancy: viewModel.isProfileTask(at: indexPath.row),
                                          imageURL: task.imageURL)
        cell.setup(cellOptions: options, action: {
            self.viewModel.taskActionSelected(at: indexPath.row)
        }, theme: theme)
        return cell
    }
    
    func didScrollToPage(_ index: Int) {
        viewModel.taskDidComeIntoFocus(at: index)
    }

}

// MARK: - AnalyticsIdentifiable
extension HomeViewController: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.home.analyticsIdentifier
    }
    
}
