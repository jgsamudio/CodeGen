//
//  MyHappeningsViewController.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Velar

final class MyHappeningsViewController: BuildableViewController {

    // MARK: - Public Properties

    var viewModel: MyHappeningsViewModel! {
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
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
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

    private var eventModal: EventModal?
    
    private var isInitialLoad = true

    // MARK: - Public Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        viewModel.loadEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.layer.shadowOpacity = tableView.navigationShadowOpacity
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.layer.shadowOpacity = 0.0
    }

}

// MARK: - Private Functions
private extension MyHappeningsViewController {

    func setupDesign() {
        view.backgroundColor = theme.colorTheme.secondary
        view.addSubview(tableView)
        view.insertSubview(refreshView, belowSubview: tableView)
        refreshView.autoPinEdge(.top, to: .top, of: view)
        refreshView.autoPinEdge(.leading, to: .leading, of: view)
        refreshView.autoPinEdge(.trailing, to: .trailing, of: view)
        tableView.autoPinEdgesToSuperviewEdges()
        setupNavigationBar()
    }

    func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "bold_black_back_button"), style: .plain, target: self, action: #selector(backButtonSelected))
        let buttonOffsetItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        buttonOffsetItem.width = 6.0
        navigationItem.leftBarButtonItems = [buttonOffsetItem, backButton]

        navigationController?.navigationBar.clipsToBounds = false
        navigationController?.setNavigationBar(backgroundColor: theme.colorTheme.secondary,
                                                               tintColor: theme.colorTheme.emphasisQuintary,
                                                               textStyle: theme.textStyleTheme.headline3)
        navigationController?.addDropShadow(color: theme.colorTheme.emphasisQuintary,
                                                            offset: ViewConstants.navigationBarShadowOffset,
                                                            radius: ViewConstants.navigationBarShadowRadius)
    }

    @objc func backButtonSelected() {
        navigationController?.popViewController(animated: true)
    }
    
    func setLoadingIndicator(loading: Bool) {
        activityIndicator.isLoading(loading: loading)
        tableView.tableFooterView = loading ? activityIndicator : nil
    }

}

// MARK: - UITableViewDataSource
extension MyHappeningsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let data = viewModel.eventData(index: indexPath.row)
        cell.setup(theme: theme,
                   data: data,
                   isLoading: viewModel.isInitialLoad,
                   delegate: self,
                   options: HomeEventCellViewOptions())
        return cell
    }

}

// MARK: - UITableViewDelegate
extension MyHappeningsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventID = viewModel.eventID(index: indexPath.row)
        let data = viewModel.eventData(index: indexPath.row)
        let viewController = builder.eventDetailViewController(eventId: eventID,
                                                               eventData: data,
                                                               eventStatusDelegate: viewModel)
        analyticsProvider.track(event: AnalyticsEvents.Happenings.cellTapped.analyticsIdentifier,
                                properties: data?.analyticsProperties(forScreen: self),
                                options: nil)
        navigationController?.pushViewController(viewController, animated: true)
    }

}

// MARK: - MyHappeningsViewDelegate
extension MyHappeningsViewController: MyHappeningsViewDelegate {
    
    func attemptToPresentPushPermission() {
        presentPushPermissionAlertIfNeeded()
    }
    
    func displayEvents() {
        tableView.reloadData()
    }

    func loading(_ isLoading: Bool) {
        tableView.isUserInteractionEnabled = viewModel.userInteractionEnabled(isLoading: isLoading)

        if viewModel.isInitialLoad {
            tableView.reloadData()
        } else {
            setLoadingIndicator(loading: isLoading)
        }
    }

    func displayEventModal(data: EventModalData) {
        eventModal = EventModal(theme: theme, type: data.type, delegate: eventModalActionRouter, calendarViewDelegate: self)
        if let modal = eventModal {
            modal.setup(eventData: data)
            velarPresenter.show(view: modal, animate: true)
        }
    }

    func addGuestSelected(eventData: EventData) {
        eventModalActionRouter.addGuestSelected(eventData: eventData)
        analyticsProvider.track(event: AnalyticsEvents.Happenings.editGuests.analyticsIdentifier,
                                properties: eventData.analyticsProperties(forScreen: self),
                                options: nil)
    }

    func reloadEventCell(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }

    func set(isLoading: Bool) {
        if isInitialLoad {
            if !isLoading {
                isInitialLoad = false
            }
            return
        }
        
        refreshView.setIsLoading(isLoading, scrollView: tableView)
    }

}

// MARK: - UIScrollViewDelegate
extension MyHappeningsViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationController?.navigationBar.layer.shadowOpacity = scrollView.navigationShadowOpacity
        if scrollView.scrolledPastThreshold(ViewConstants.paginateScrollPercentage) &&
            !viewModel.eventCountIsLessThanPageSize {
            viewModel.loadEvents()
        }
        refreshView.scrollViewDidScroll(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshView.scrollViewDidEndDragging(scrollView)
    }
    
}

// MARK: - RefreshControlDelegate
extension MyHappeningsViewController: RefreshControlDelegate {
    
    func reload() {
        viewModel.resetPagination()
        viewModel.loadEvents()
    }
    
}

// MARK: - EventCellDelegate
extension MyHappeningsViewController: EventCellDelegate {

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
extension MyHappeningsViewController: AddToCalendarViewDelegate {

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

// MARK: - AnalyticsIdentifiable
extension MyHappeningsViewController: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.myEvents.analyticsIdentifier
    }
    
}
