//
//  LeaderboardResultViewController.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/2/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simcoe

/// View controller for showing results of leaderboard searches.
final class LeaderboardResultViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var iOS10Constraint: NSLayoutConstraint!
    @IBOutlet private weak var iOS11Constraint: NSLayoutConstraint!
    @IBOutlet private weak var customTitleView: UIView!
    @IBOutlet private weak var customTitleLabel: UILabel!
    @IBOutlet private weak var sortButton: UIBarButtonItem!

    var viewModel: LeaderboardResultViewModel! {
        didSet {
            tableView?.prefetchDataSource = viewModel.prefetchController
        }
    }

    private weak var loadingView: UIView?

    private let topContentInset: CGFloat = 16

    private var timer: CFTimer!

    private var isEmptyStateViewHidden: Bool {
        return !viewModel.isValidNumberOfAthletesAvailable
            || viewModel.numberOfLines > 0
    }

    /// Track the current following athlete
    private var currentFollowingAthleteIndex: IndexPath!

    /// Track the previous following athlete
    private var previousFollowingAthleteIndex: IndexPath!

    private var followingAthleteModalViewController: FollowAnAthleteModalViewController!

    private var followingAthleteId: String?

    /// Layout of the screen.
    var layout: LeaderboardResultLayout = .default

    /// Filter view model which can be passed to a presented filter view controller in order to adjust the
    /// leaderboard content shown in `self`. This variable has to be set appropriately to reflect the content
    /// provided in `viewModel`.
    var filterViewModel: LeaderboardFilterContent! {
        didSet {
            filterViewModel.delegate = self
        }
    }

    lazy var topDrawerController = {
        TopDrawerTransitionDelegate(initialContentOffset: { [weak self] in
            let tableViewTopConstraint: NSLayoutConstraint?
            if #available(iOS 11.0, *) {
                tableViewTopConstraint = self?.iOS11Constraint
            } else {
                tableViewTopConstraint = self?.iOS10Constraint
            }
            return (self?.navigationController?.navigationBar.bounds.height ?? 0)
                + UIApplication.shared.statusBarFrame.height
                + (tableViewTopConstraint?.constant ?? 0)
        }, contentOffsetChanged: { [weak self] topDrawerContentOffset in
            guard let tableView = self?.tableView else {
                return
            }

            let safeAreaHeight: CGFloat
            let topConstraint: CGFloat
            if #available(iOS 11.0, *) {
                safeAreaHeight = self?.view.safeAreaInsets.top ?? 0
                topConstraint = self?.iOS11Constraint.constant ?? 0
            } else {
                let navBarHeight = self?.navigationController?.navigationBar.bounds.height ?? 0
                let statusBarHeight = UIApplication.shared.statusBarFrame.height
                safeAreaHeight = navBarHeight + statusBarHeight
                topConstraint = self?.iOS10Constraint.constant ?? 0
            }
            tableView.transform = CGAffineTransform(translationX: 0, y: max(topDrawerContentOffset - topConstraint - safeAreaHeight, 0))
        })
    }()

    private var expandedIndexPaths: [IndexPath] = []

    private let localization = LeaderboardLocalization()
    private let generalLocalization = GeneralLocalization()
    private var topView: ScrollViewShrinkableTopView?
    private var oldNavBarStyle: NavBarStyle?

    private var refreshObserver: AnyObject?
    private var scrollObserver: AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            iOS10Constraint.isActive = false
            extendedLayoutIncludesOpaqueBars = true
        } else {
            iOS11Constraint.isActive = false
        }

        let nib = UINib(nibName: String(describing: FilterSelectionHeaderView.self), bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: FilterSelectionHeaderView.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = LeaderboardAthleteResultCell.heightEstimate
        tableView.prefetchDataSource = viewModel.prefetchController
        tableView.refreshControl = IOS11CompatibleRefreshControl()

        switch layout {
        case .minimalLeaderboard(title: _, subtitle: _, isAffiliateLeaderboard: _):
            break
        default:
            topView = UINib(nibName: String(describing: ScrollViewShrinkableTopView.self), bundle: nil)
                .instantiate(withOwner: self, options: nil).first as? ScrollViewShrinkableTopView
            if #available(iOS 11.0, *) {
                topView?.attach(to: tableView, scrollViewTopConstraint: iOS11Constraint)
            } else {
                topView?.attach(to: tableView, scrollViewTopConstraint: iOS10Constraint)
            }
            topView?.callback = showFilters
            topView?.buttonTitle = generalLocalization.filter
            topView?.additionalInset = topContentInset
        }

        NotificationCenter.default.addObserver(self, selector: #selector(observeFollowAnAthlete),
                                               name: NotificationName.followingAthleteDidUpdate.name,
                                               object: nil)

        loadFilters()
        adjustLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        switch layout {
        case .default:
            break
        case .minimalLeaderboard(title: _, subtitle: _, isAffiliateLeaderboard: _):
            if oldNavBarStyle == nil {
                oldNavBarStyle = NavBarStyle(navBar: navigationController?.navigationBar)
            }
            NavBarStyle.blurry.apply(to: navigationController?.navigationBar)
            if #available(iOS 11, *) {} else {
                self.extendedLayoutIncludesOpaqueBars = true
            }

            loadingView?.transform.tx = view.bounds.width
            view.alpha = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.loadingView?.transform.tx = 0
            }, completion: {_ in
                self.view.alpha = 1
            })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        switch layout {
        case .default:
            break
        case .minimalLeaderboard(title: _, subtitle: _, isAffiliateLeaderboard: _):
            oldNavBarStyle?.apply(to: navigationController?.navigationBar)
            oldNavBarStyle = nil
        }
    }

    @IBAction private func searchBarButtonTapped(_ sender: UIBarButtonItem) {
        guard let leaderboard = viewModel.customLeaderboard else {
            return
        }
        let searchViewController = SearchBuilder(leaderboard: leaderboard).build()
        searchViewController.modalPresentationStyle = .custom
        searchViewController.modalTransitionStyle = .crossDissolve
        present(searchViewController, animated: true, completion: nil)
        Simcoe.track(event: .leaderboardSearchStarted,
                     withAdditionalProperties: [:],
                     on: .leaderboard)
    }

    @objc private func observeFollowAnAthlete(_ notification: NSNotification) {
        if let userInfo = notification.userInfo,
            let isFromDashboard = userInfo[NotificationKey.isFromDashBoard] as? Bool,
            isFromDashboard,
            let currentFollowingAthleteIndex = currentFollowingAthleteIndex {
            tableView.reloadRows(indexPaths: [currentFollowingAthleteIndex])
        }
    }

    private func loadCurrentFollowingAthlete() {
        followingAthleteId = viewModel.followingAthleteId
    }

    private func refresh() {
        viewModel.refresh()
        UIView.animate(withDuration: 0.3, animations: {
            self.displayLoader()
            self.tableView.refreshControl?.endRefreshing()
        }, completion: { [weak self] (complete) in
            guard let viewModel = self?.viewModel, complete else {
                return
            }

            self?.viewShouldReload(with: viewModel, scrollingToAthlete: nil, onPage: nil)
            if #available(iOS 11.0, *) {
                switch self?.layout {
                case .some(.default):
                    self?.navigationItem.largeTitleDisplayMode = .never
                    self?.navigationItem.largeTitleDisplayMode = .always
                default:
                    break
                }
            }
        })
    }

    /// Displays results view controller and removes loader view controller
    private func displayResults() {
        if loadingView?.alpha != 0 {
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                self?.loadingView?.alpha = 0
                }, completion: { [weak self] _ in
                    self?.loadingView?.removeFromSuperview()
            })
        }
    }

    /// Displays loader
    private func displayLoader() {
        if loadingView == nil {
            let loadingView: LeaderboardLoadingView = LeaderboardLoadingView.showOn(viewController: navigationController ?? self)
            let topViewHeight: CGFloat = topView?.bounds.size.height ?? 0.0

            let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? 0
            loadingView.headerHeight = navigationBarHeight + topViewHeight + topContentInset
            self.loadingView = loadingView
        }
    }

    private func adjustLayout() {
        switch layout {
        case .default:
            break
        case .minimalLeaderboard(title: let title, subtitle: let subtitle, isAffiliateLeaderboard: let isAffiliateLeaderboard):
            self.title = title
            customTitleLabel.text = title.appending(subtitle.flatMap { "\n\($0)" } ?? "")
            customTitleView.frame.size.width = min(customTitleLabel.sizeThatFits(UILayoutFittingCompressedSize).width,
                                                   240)
            navigationItem.titleView = customTitleView

            if #available(iOS 11.0, *) {
                navigationItem.largeTitleDisplayMode = .never
            }
            navigationItem.leftBarButtonItem = nil
            if isAffiliateLeaderboard {
                let filterButton = UIBarButtonItem(title: generalLocalization.filter,
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(showAffiliateFilters))
                navigationItem.rightBarButtonItem = nil
                navigationItem.rightBarButtonItem = filterButton
            } else {
                navigationItem.rightBarButtonItem = nil
            }
            tableView.contentInset.top = topContentInset
        }
    }

    @objc private func showAffiliateFilters() {
        let filterBuilder = FilterBuilder(themeConfig: FilterThemeConfiguration.blue,
                                          viewModel: filterViewModel,
                                          addBarButtons: true,
                                          filterAdjustment: .includedFilters(names: [.division, .workoutType]),
                                          presentingViewController: nil,
                                          customTitle: nil)
        let viewController = filterBuilder.build()
        viewController.navigationItem.rightBarButtonItem = nil
        let presentedViewController = UINavigationController(rootViewController: viewController)
        presentedViewController.transitioningDelegate = topDrawerController
        presentedViewController.modalPresentationStyle = .custom
        present(presentedViewController, animated: true, completion: nil)
    }

    private func showFilters() {
        let filterBuilder = FilterBuilder(themeConfig: FilterThemeConfiguration.blue,
                                          viewModel: filterViewModel,
                                          addBarButtons: true,
                                          filterAdjustment: .excludedFilters(names: [.sort]),
                                          presentingViewController: nil,
                                          customTitle: nil)
        let presentedViewController = UINavigationController(rootViewController: filterBuilder.build())
        presentedViewController.transitioningDelegate = topDrawerController
        presentedViewController.modalPresentationStyle = .custom
        present(presentedViewController, animated: true, completion: nil)
    }

    @IBAction private func showSort() {
        let filterBuilder = FilterBuilder(themeConfig: FilterThemeConfiguration.white,
                                          viewModel: filterViewModel,
                                          addBarButtons: true,
                                          filterAdjustment: .expandedFilter(name: .sort),
                                          presentingViewController: nil,
                                          customTitle: GeneralLocalization().sort)
        let rootViewController = filterBuilder.build()
        rootViewController.navigationItem.rightBarButtonItem = nil
        let presentedViewController = UINavigationController(rootViewController: rootViewController)
        presentedViewController.transitioningDelegate = topDrawerController
        presentedViewController.modalPresentationStyle = .custom
        present(presentedViewController, animated: true, completion: nil)
    }

    private func loadFilters(isRetryAttempt: Bool = false, completion: @escaping (Error?) -> Void = { _ in }) {
        filterViewModel.loadFiltersIfNeeded(completion: { [weak self] error in
            if let error = error {
                guard let navView = self?.navigationController?.view else {
                    return
                }

                if isRetryAttempt {
                    completion(error)
                } else {
                    switch error {
                    case APIError.forceUpdate(title: let title, message: let message, storeLink: let storeLink):
                        KillSwitchManager.hideWindow()
                        KillSwitchManager.showForceUpdateAlert(title: title, message: message, storeLink: storeLink)
                    case APIError.inactive(title: let title, message: let message):
                        FullscreenErrorView.presentWindow(title: title, message: message, onTap: { [weak self] retry in
                            self?.loadFilters(isRetryAttempt: true, completion: retry)
                        })
                    default:
                        FullscreenErrorView.cover(navView, onTap: { retry in
                            self?.loadFilters(isRetryAttempt: true, completion: retry)
                        })
                    }

                }
            } else {
                KillSwitchManager.hideWindow()
                completion(error)
            }
        })
    }

    private func hideShowSearchIcon(customLeaderboardName: String?) {
        guard let name = viewModel.customLeaderboard?.selectedControls.type else {
            return
        }
        var shouldHide = (name == Competition.regionals.searchQueryString
            || name == Competition.games.searchQueryString
            || name == Competition.onlineQualifier.searchQueryString)
        switch layout {
        case .minimalLeaderboard(title: _, subtitle: _, isAffiliateLeaderboard: _):
            shouldHide = true
        default:
            break
        }

        if shouldHide {
            navigationItem.leftBarButtonItem = nil
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "SearchIcon"),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(searchBarButtonTapped))
        }
    }

    @objc private func handleTimer() {
        if let followingAthleteModalViewController = followingAthleteModalViewController {
            followingAthleteModalViewController.dismissView()
        }
    }

}

// MARK: - UITableViewDataSource
extension LeaderboardResultViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEmptyStateViewHidden ? viewModel.numberOfLines : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isEmptyStateViewHidden {
            let cell: EmptyLeaderboardCell = tableView.dequeueCell(forIndexPath: indexPath)
            cell.setNoResultsLabelText(text: localization.filtersNoResults)
            return cell
        } else if let presentableViewModel = viewModel.presentableViewModel(for: indexPath) {
            let athleteCell: LeaderboardAthleteResultCell = tableView.dequeueCell(forIndexPath: indexPath)
            athleteCell.shouldHideFAAButton = (viewModel.customLeaderboard?.selectedControls.type == Competition.onlineQualifier.searchQueryString)
            athleteCell.viewModel = presentableViewModel
            athleteCell.indexPath = indexPath
            athleteCell.followAnAthleteDelegate = self
            athleteCell.isExpanded = expandedIndexPaths.contains(indexPath)

            /// Checks for the index of the currently following athlete id
            if let currentFollowingAthleteId = followingAthleteId,
                presentableViewModel.id == currentFollowingAthleteId {
                previousFollowingAthleteIndex = indexPath
                currentFollowingAthleteIndex = indexPath
            }
            return athleteCell
        } else {
            let cell: LeaderboardResultLoaderTableViewCell = tableView.dequeueCell(forIndexPath: indexPath)
            cell.hideTopSeparator()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandedIndexPaths.index(of: indexPath) != nil || !isEmptyStateViewHidden {
            return UITableViewAutomaticDimension
        }
        return LeaderboardAthleteResultCell.heightEstimate
    }

}

// MARK: - UITableViewDelegate
extension LeaderboardResultViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = expandedIndexPaths.index(of: indexPath) {
            expandedIndexPaths.remove(at: index)
        } else {
            expandedIndexPaths.append(indexPath)
        }

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(indexPaths: [indexPath])
    }

}

// MARK: - UIScrollViewDelegate
extension LeaderboardResultViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topView?.scrollViewDidScroll(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        topView?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if tableView.refreshControl?.isRefreshing == true {
            refresh()
        }
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if #available(iOS 11.0, *) {
            scrollObserver = tableView.observe(\.contentOffset,
                                               options: NSKeyValueObservingOptions.new,
                                               changeHandler: { [weak self] (sv, change) in
                                                if change.newValue?.y == 0 {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                                        sv.setContentOffset(.zero, animated: true)
                                                    })
                                                    self?.scrollObserver = nil
                                                }
            })
        }
        return true
    }

}

// MARK: - FollowAnAthleteDelegate
extension LeaderboardResultViewController: FollowAnAthleteDelegate {

    func didTap(isAdded: Bool, indexPath: IndexPath, athleteId: String?) {
        let tempPrevious = previousFollowingAthleteIndex ?? indexPath
        let prevCurrentIndex = currentFollowingAthleteIndex

        loadCurrentFollowingAthlete()

        if isAdded, let athleteId = athleteId {
            UISelectionFeedbackGenerator().selectionChanged()
            viewModel?.saveCustomLeaderboardForAthlete()
            viewModel.getFollowingAthlete(by: athleteId, completion: { [weak self] (_, error) in
                if (error as? LeaderboardSearchError) != nil {
                    BannerManager.showBanner(text: self?.localization.faaCannotFollowError ?? "",
                                             onTap: {},
                                             delegate: nil,
                                             duration: 2.5)
                    self?.currentFollowingAthleteIndex = prevCurrentIndex
                } else {
                    self?.presentModalView(prevIndexPath: tempPrevious, currentIndexPath: indexPath)
                    if let followingAthlete = self?.viewModel.presentableViewModel(for: indexPath) {
                        self?.viewModel?.followAnAthlete(with: followingAthlete)
                    }

                    self?.postFollowAnAthleteUpdateNotification()
                }
                self?.reloadRows(with: indexPath)
                self?.currentFollowingAthleteIndex = indexPath
                self?.previousFollowingAthleteIndex = indexPath

            })
        } else {
            viewModel?.unFollowAthlete()
            reloadRows(with: indexPath)
            currentFollowingAthleteIndex = nil
            previousFollowingAthleteIndex = nil
            postFollowAnAthleteUpdateNotification()
        }
    }

    private func reloadRows(with indexPath: IndexPath) {
        loadCurrentFollowingAthlete()
        if let previousFollowingAthleteIndex = previousFollowingAthleteIndex,
            previousFollowingAthleteIndex.row < viewModel.numberOfLines {
            tableView.reloadRows(indexPaths: [indexPath, previousFollowingAthleteIndex])
        } else {
            tableView.reloadRows(indexPaths: [indexPath])
        }
    }

    private func postFollowAnAthleteUpdateNotification() {
        /// Notifies, so that the relevant updates could be made in the dashboard
        NotificationCenter.default.post(name: NotificationName.followingAthleteDidUpdate.name, object: nil)
    }

    private func presentModalView(prevIndexPath: IndexPath, currentIndexPath: IndexPath) {
        var isSingleAthleteView = false
        let previousAthlete = viewModel.followingAthleteViewModel
        if let previousAthlete = previousAthlete {
            if prevIndexPath == currentIndexPath,
                let currentFollowingAthlete = viewModel.presentableViewModel(for: currentIndexPath),
                previousAthlete.id == currentFollowingAthlete.id {
                isSingleAthleteView = true
            } else {
                isSingleAthleteView = false
            }
        } else {
            previousFollowingAthleteIndex = nil
            isSingleAthleteView = true
        }

        if let currentFollowingAthlete = viewModel.presentableViewModel(for: currentIndexPath) {
            Simcoe.track(event: .followAthleteAdd, withAdditionalProperties:
                [.athleteId: currentFollowingAthlete.id,
                 .athleteName: currentFollowingAthlete.name ?? ""],
                     on: .followAthlete)
            let followAnAthleteViewModel = FollowAnAthleteViewModel(followingAthlete: currentFollowingAthlete, previousAthlete: previousAthlete)
            if let followingAthleteModalViewController =
                FollowAnAthleteModalBuilder(
                    viewModel: followAnAthleteViewModel).build() as? FollowAnAthleteModalViewController {
                self.followingAthleteModalViewController = followingAthleteModalViewController
                self.followingAthleteModalViewController.isSingleAthleteView = isSingleAthleteView
                self.followingAthleteModalViewController.delegate = self
                self.followingAthleteModalViewController.modalPresentationStyle = .overCurrentContext
                present(self.followingAthleteModalViewController, animated: false, completion: nil)
                /// Initiates a timer to manage the visible time of the pop up
                timer = CFTimer(interval: 4, repeats: false)
                timer.start(handler: #selector(handleTimer), target: self)
            }
        } else {
            Simcoe.track(event: .followAthleteRemove,
                         withAdditionalProperties: [:], on: .followAthlete)
        }
    }

    func modalDismissed() {
        /// Invalidates the timer when the modal is dismissed
        if timer != nil {
            timer.invalidate()
        }
    }

}

// MARK: - LeaderboardFilterResponder
extension LeaderboardResultViewController: LeaderboardFilterResponder {

    func viewShouldReload(with viewModel: LeaderboardResultViewModel,
                          scrollingToAthlete athleteId: String?,
                          onPage page: Int?,
                          showingLoadingView: Bool = true) {
        self.viewModel = viewModel
        topView?.content = self.viewModel.getSelectedFilters()
        topView?.collapsedContent = self.viewModel.getSelectedFilters(includeSort: false)
        hideShowSearchIcon(customLeaderboardName: viewModel.customLeaderboard?.selectedControls.name)
        expandedIndexPaths = []
        loadCurrentFollowingAthlete()
        tableView.reloadData()

        if showingLoadingView {
            displayLoader()
        }
        // Get leaderboard list.
        viewModel.retrieveLeaderboardList(searchingFor: athleteId, onPage: page) { [weak self] indexPath, _ in
            guard let wself = self else {
                return
            }
            // If searching for an athlete and we found the athlete, set that athlete as expanded.
            if let indexPath = indexPath {
                // Some other animation will probably happen here.
                wself.expandedIndexPaths = [indexPath]
            }

            wself.tableView.reloadData()
            if let indexPath = indexPath, indexPath.row < viewModel.numberOfLines {
                wself.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            }
            self?.displayResults()
            wself.topView?.scrollViewDidScroll(wself.tableView)
        }

        switch layout {
        case .minimalLeaderboard(title: let title, subtitle: let subtitle, isAffiliateLeaderboard: let isAffiliateLeaderboard):
            layout = .minimalLeaderboard(title: title,
                                         subtitle: viewModel.divisionName ?? subtitle,
                                         isAffiliateLeaderboard: isAffiliateLeaderboard)
            adjustLayout()
        default:
            break
        }

        if filterViewModel.hasSortOptions {
            switch layout {
            case .default:
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sort"), style: .plain, target: self, action: #selector(showSort))
            case .minimalLeaderboard(title: _, subtitle: _, isAffiliateLeaderboard: _):
                return
            }
        } else {
            switch layout {
            case .default:
                navigationItem.rightBarButtonItem = nil
            case .minimalLeaderboard(title: _, subtitle: _, isAffiliateLeaderboard: _):
                return
            }

        }
    }

}

// MARK: - FilterSelectionHeaderViewDelegate
extension LeaderboardResultViewController: FilterSelectionHeaderViewDelegate {

    func didSelectFilters(on headerView: FilterSelectionHeaderView) {
        showFilters()
    }

}

// MARK: - LeaderboardFilterSubscriber
extension LeaderboardResultViewController: LeaderboardFilterSubscriber {

    func filtersChanged(on selectionService: LeaderboardFilterSelectionService) {
        tableView.reloadData()
    }

}

// MARK: - TabBarTappable
extension LeaderboardResultViewController: TabBarTappable {

    func handleTabBarTap() {
        guard let presentedVC = presentedViewController as? FilterViewController else {
            tableView.setContentOffset(.zero, animated: true)
            return
        }
        presentedVC.handleTabBarTap()
    }

}
