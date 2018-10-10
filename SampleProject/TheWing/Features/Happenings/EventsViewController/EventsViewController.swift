//
//  EventsViewController.swift
//  TheWing
//
//  Created by Jonathan Samudio on 2/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Velar

/// Events view controller.
final class EventsViewController: TabBarItemViewController {
    
    // MARK: - Public Properties
    
    /// Events view model.
    var viewModel: EventsViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.registerCell(cellClass: EventTableViewCell.self)
        tableView.registerHeaderFooterView(EventsCalendarSectionHeader.self)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = 50
        return tableView
    }()
    
    private lazy var refreshControlView: RefreshControlView = {
        let controlView = RefreshControlView(indicatorColor: colorTheme.primary)
        controlView.backgroundColor = colorTheme.secondary
        let textStyle = textStyleTheme.captionNormal.withColor(colorTheme.emphasisSecondary)
        controlView.refreshLabel.setMarkdownText("**\(HomeLocalization.pullToRefreshTitle.uppercased())**", using: textStyle)
        controlView.bottomImageView.image = #imageLiteral(resourceName: "separator_icon")
        controlView.delegate = self
        return controlView
    }()
    
    private lazy var activityIndicator: LoadingIndicator = {
        let indicator = LoadingIndicator(activityIndicatorViewStyle: .gray)
        indicator.frame = ViewConstants.loadingIndicatorFooterFrame
        return indicator
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

    private lazy var noResultsView = NoResultsView(theme: theme, delegate: self)
    
    private var eventModal: EventModal?
    
    // MARK: - Public Functions
    
    override func tabBarItemTitle() -> String {
        return "HAPPENINGS_TAB_TITLE".localized(comment: "Happenings")
    }
    
    override func tabBarIcon() -> (selected: UIImage?, unselected: UIImage?) {
        return (#imageLiteral(resourceName: "happenings-active"), #imageLiteral(resourceName: "happenings-inactive"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        viewModel.loadEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateLoadedEvents()
        viewModel.resyncEventsPage()
    }

}

// MARK: - Private Functions
private extension EventsViewController {
    
    func setupDesign() {
        view.backgroundColor = colorTheme.secondary
        setupTableView()
        setupRefreshControl()
        setupNoResultsView()
    }
    
    func setupTableView() {
        view.insertSubview(tableView, belowSubview: headerView)
        tableView.autoPinEdgesToSuperviewEdges(excludingEdge: .top)
        tableView.autoPinEdge(.top, to: .bottom, of: headerView)
    }

    func setupNoResultsView() {
        view.insertSubview(noResultsView, aboveSubview: tableView)
        noResultsView.autoPinEdgesToSuperviewEdges(excludingEdge: .top)
        noResultsView.autoPinEdge(.top, to: .bottom, of: headerView)
        noResultsView.transition(show: false, animate: false)
        noResultsView.updateTopConstant(constant: UIScreen.isSmall ? 45 : 100)
    }
    
    func setupRefreshControl() {
        view.insertSubview(refreshControlView, belowSubview: tableView)
        refreshControlView.autoPinEdge(.top, to: .bottom, of: headerView)
        refreshControlView.autoPinEdge(.leading, to: .leading, of: view)
        refreshControlView.autoPinEdge(.trailing, to: .trailing, of: view)
    }
    
    func setLoadingIndicator(loading: Bool) {
        refreshControlView.setIsLoading(loading, scrollView: tableView)
        activityIndicator.isLoading(loading: loading)
        tableView.tableFooterView = loading ? activityIndicator : nil
    }
    
}

// MARK: - EventsViewDelegate
extension EventsViewController: EventsViewDelegate {
    
    func attemptToPresentPushPermission() {
        presentPushPermissionAlertIfNeeded()
    }

    func reset() {
        tableView.reloadData()
        view.layoutIfNeeded()
    }
    
    func loading(_ isLoading: Bool) {
        tableView.isUserInteractionEnabled = viewModel.userInteractionEnabled(isLoading: isLoading)

        if viewModel.isInitialLoad {
            tableView.reloadData()
        } else {
            setLoadingIndicator(loading: isLoading)
        }
    }
    
    func displayEvents() {
        tableView.reloadData()
    }
    
    func setFilterCount(_ count: Int) {
        (headerView as? FilterSearchTabHeaderView)?.setFilterCount(count)
    }
    
    func displayEventModal(data: EventModalData) {
        eventModal = EventModal(theme: theme, type: data.type, delegate: eventModalActionRouter, calendarViewDelegate: self)
        if let modal = eventModal {
            modal.setup(eventData: data)
            velarPresenter.show(view: modal, animate: true)
        }
    }

    func reloadEventCell(at section: Int, row: Int) {
        let indexPath = IndexPath(row: row, section: section)
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func addGuestSelected(eventData: EventData) {
        analyticsProvider.track(event: AnalyticsEvents.Happenings.editGuests.analyticsIdentifier,
                                properties: eventData.analyticsProperties(forScreen: self),
                                options: nil)
        eventModalActionRouter.addGuestSelected(eventData: eventData)
    }

    func displayNoResultsView(show: Bool) {
        noResultsView.transition(show: show, animate: true)
    }

}

// MARK: - UITableViewDataSource
extension EventsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let data = viewModel.eventData(section: indexPath.section, index: indexPath.row)
        cell.setup(theme: theme,
                   data: data,
                   isLoading: viewModel.isInitialLoad,
                   delegate: self,
                   options: ListEventCellViewOptions(data: data))
        return cell
    }

}

// MARK: - UITableViewDelegate
extension EventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: EventsCalendarSectionHeader = tableView.dequeueReusableHeaderFooterView()
        header.setup(theme: theme, date: viewModel.dateComponents(for: section), isLoading: viewModel.isInitialLoad)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventID = viewModel.eventID(section: indexPath.section, index: indexPath.row)
        let data = viewModel.eventData(section: indexPath.section, index: indexPath.row)
        let viewController = builder.eventDetailViewController(eventId: eventID,
                                                               eventData: data,
                                                               eventStatusDelegate: viewModel)
        analyticsProvider.track(event: AnalyticsEvents.Happenings.cellTapped.analyticsIdentifier,
                                properties: data?.analyticsProperties(forScreen: self),
                                options: nil)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - UIScrollViewDelegate
extension EventsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.scrolledPastThreshold(ViewConstants.paginateScrollPercentage) {
            viewModel.loadEvents()
        }
        refreshControlView.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshControlView.scrollViewDidEndDragging(scrollView)
    }
    
}

// MARK: - EventCellDelegate
extension EventsViewController: EventCellDelegate {
    
    func actionButtonSelected(data: EventData) {
        viewModel.actionButtonSelected(with: data)
    }
    
    func bookmarkSelected(data: EventData?) {
        guard let data = data else {
            return
        }
        
        if viewModel.toggleBookmarkStatus(eventData: data) {
            showSnackBar(with: SnackBarLocalization.bookmarkAdded, dismissAfter: 3)
        }
    }
    
}

// MARK: - AddToCalendarViewDelegate
extension EventsViewController: AddToCalendarViewDelegate {
    
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

// MARK: - NoResultDelegate
extension EventsViewController: NoResultDelegate {

    func refineFiltersSelected() {
        headerView.resetSearchField(hasSearchText: viewModel.searchTerm?.nilIfEmpty != nil)
        viewModel.resetSearchAndFilter()
    }

}

// MARK: - RefreshControlDelegate
extension EventsViewController: RefreshControlDelegate {
    
    func reload() {
        viewModel.reset()
    }
    
}

// MARK: - FilterSearchTabHeaderViewDelegate
extension EventsViewController: FilterSearchTabHeaderViewDelegate {
    
    func filterButtonSelected() {
        present(builder.filtersViewController(filtersDelegate: viewModel), animated: true, completion: nil)
    }
    
    func animateHeaderConstraints(with offset: CGFloat) {
        headerViewTopConstraint?.constant = offset
        animateConstraints()
    }
    
    func displaySearchResult(with searchText: String?) {
        viewModel.search(searchText)
    }
    
    func cancelSearch() {
        viewModel.search(nil)
    }
    
}

// MARK: - AnalyticsIdentifiable
extension EventsViewController: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.events.analyticsIdentifier
    }
    
}
