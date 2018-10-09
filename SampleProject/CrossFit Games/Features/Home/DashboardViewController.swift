//
//  DashboardViewController.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/10/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import Simcoe

/// View controller for dashboard section of the app.
final class DashboardViewController: BaseViewController {

    // MARK: - Private Properties
    
    @IBOutlet private weak var pageControl: UIPageControl!

    @IBOutlet private weak var collectionView: UICollectionView!

    @IBOutlet private weak var accountImageView: UIImageView!
    @IBOutlet private weak var accountTitleLabel: StyleableLabel!
    @IBOutlet private weak var accountSubtitleLabel: StyleableLabel!

    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var buttonStack: UIStackView!
    @IBOutlet private weak var registerForOpenView: UIView!
    @IBOutlet private weak var followAnAthleteViewContainer: UIView!

    @IBOutlet private weak var registerView: UIView!
    @IBOutlet private weak var shareView: UIView!

    @IBOutlet private weak var coachMark: CoachMark!

    // MARK: - Public Properties
    
    var viewModel: DashboardViewModel!
    private var followAnAthleteViewModel: DashboardFollowAnAthleteViewModel!

    var dashboardCards: [DashboardCardViewModel] = []
    var personalizedLeaderboard: PersonalizedLeaderboard?

    private var showingUnregisteredState: Bool {
        return dashboardCards.count == 0
    }

    private var showingFailureState: Bool {
        return personalizedLeaderboard?.isInvalid == true
    }

    private var displayedPromoItems: [DashboardPromoItem] = []

    private weak var containerViewController: CardDetailContainerViewController?
    private weak var loadingView: DashboardLoadingView?

    private let localization = DashboardStatsLocalization()
    private let dashboardLocalization = DashboardLocalization()
    private let refreshCoordinator = DashboardRefreshCoordinator()

    var window1: UIWindow!

    private var animationSafeRegion: CGFloat {
        return view.bounds.width / 100 * 56
    }

    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(observeLogin), name: NotificationName.userDidLogin.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(observeFollowAnAthlete),
                                               name: NotificationName.followingAthleteDidUpdate.name,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(observeRefresh),
                                               name: NotificationName.appDidBecomeActive.name,
                                               object: nil)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }

        pageControl.hidesForSinglePage = true
        collectionView.dataSource = self
        collectionView.delegate = self

        loadingView = DashboardLoadingView.install(in: view, over: scrollView)

        coachMark.isHidden = true
        updatePersonalizedLeaderboard()
        updatePromoItems()
        refreshCoordinator.lastRefresh = DatePicker.shared.date
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
        observeRefresh()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        coachMark.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @objc private func observeRefresh() {
        if refreshCoordinator.shouldRefresh {
            viewModel.refreshFollowingAthleteCache()
            updatePersonalizedLeaderboard() // Also triggers load follow athlete view (even when not logged in).
            updatePromoItems()
            refreshCoordinator.lastRefresh = DatePicker.shared.date
        }
    }

    @objc private func observeLogin() {
        viewModel = DashboardViewModel()
        updatePersonalizedLeaderboard()
    }

    private func updatePromoItems() {
        viewModel.getPromoItems { [weak self] (promoItems) in
            guard let wself = self else {
                return
            }
            let fixedSubviews: [UIView] = [wself.registerView, wself.shareView]

            self?.buttonStack.arrangedSubviews
                .filter { !fixedSubviews.contains($0) }
                .forEach {
                    $0.removeFromSuperview()
            }

            self?.displayedPromoItems.removeAll()
            promoItems.reversed().forEach({ (item) in
                let promoItem = DashboardPromoItem(frame: .zero)
                guard let view = UINib(nibName: String(describing: DashboardPromoItem.self),
                                       bundle: nil).instantiate(withOwner: promoItem, options: nil).first as? UIView else {
                                        return
                }
                self?.displayedPromoItems.insert(promoItem, at: 0)
                promoItem.text = item.title
                promoItem.tapAction = { [weak self] in
                    if let event = AnalyticsKey.Event(rawValue: item.key),
                        let property = AnalyticsKey.Property(rawValue: item.key) {
                        Simcoe.track(event: event,
                                     withAdditionalProperties: [property: item.title], on: .dashboard)
                    }

                    let safariViewController = SFSafariBuilder(url: item.link).build()
                    safariViewController.modalPresentationStyle = .overFullScreen
                    self?.present(safariViewController, animated: true)
                }
                view.addGestureRecognizer(UITapGestureRecognizer(target: promoItem, action: #selector(DashboardPromoItem.triggerTap)))
                self?.buttonStack.insertArrangedSubview(view, at: 0)
            })
        }
    }

    @objc private func observeFollowAnAthlete() {
        loadFollowAnAthleteView()
    }

    private func loadFollowAnAthleteView(isRetrying: Bool = false,
                                         completion: @escaping (Error?) -> Void = { _ in }) {
        /// Show loading state view
        if !isRetrying, let followAnAthleteLoadinStateView = DashboardFollowAnAthleteLoadingView().initFromNib() {
            followAnAthleteViewContainer.addSubview(followAnAthleteLoadinStateView)
            followAnAthleteLoadinStateView.pin(to: followAnAthleteViewContainer, top: 0, leading: 0, bottom: 0, trailing: 0)
        }

        viewModel.getFollowingAthlete(completion: { [weak self] (followAnAthleteViewModel, error) in
            guard let wself = self else {
                return
            }
            if !isRetrying {
                wself.followAnAthleteViewContainer.subviews.forEach({ $0.removeFromSuperview() })
            }

            if error != nil {
                /// Shows the error view if an error occurs
                if let followAnAthleteErrorView = DashboardFollowAnAthleteErrorView().initFromNib(with: { retry in
                    wself.loadFollowAnAthleteView(isRetrying: true, completion: retry)
                }) {
                    wself.followAnAthleteViewContainer.addSubview(followAnAthleteErrorView)
                    followAnAthleteErrorView.pin(to: wself.followAnAthleteViewContainer, top: 0, leading: 0, bottom: 0, trailing: 0)
                }
            } else if followAnAthleteViewModel == nil {
                /// Shows the empty state if an athlete is not followed
                if let followAnAthleteEmptyStateView = FollowAnAthleteEmptyStateView().initFromNib() {
                    wself.followAnAthleteViewContainer.addSubview(followAnAthleteEmptyStateView)
                    followAnAthleteEmptyStateView.pin(to: wself.followAnAthleteViewContainer, top: 0, leading: 0, bottom: 0, trailing: 0)
                }
            } else {
                if let followAnAthleteView = DashboardFollowAnAthleteView().initFromNib(),
                    let followAnAthleteViewModel = followAnAthleteViewModel {
                    wself.followAnAthleteViewModel = followAnAthleteViewModel
                    wself.followAnAthleteViewContainer.addSubview(followAnAthleteView)
                    followAnAthleteView.pin(to: wself.followAnAthleteViewContainer, top: 0, leading: 0, bottom: 0, trailing: 0)
                    followAnAthleteView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                                    action:
                        #selector(wself.didTapFollowAnAthleteView)))
                    followAnAthleteView.setAthleteData(with: followAnAthleteViewModel)
                }
            }
        })
    }

    @objc private func didTapFollowAnAthleteView() {
        if let followAnAthleteViewModel = followAnAthleteViewModel,
            let dashboardFAAModalViewController =
            DashboardFAAModalBuilder(
                viewModel: followAnAthleteViewModel).build() as? DashboardFAAModalViewController {
            Simcoe.track(event: .followAthleteViewStats,
                         withAdditionalProperties: [.athleteId: followAnAthleteViewModel.id,
                                                    .athleteName: followAnAthleteViewModel.name ?? ""], on: .followAthlete)
            dashboardFAAModalViewController.modalPresentationStyle = .overFullScreen
            present(dashboardFAAModalViewController, animated: false, completion: nil)
        }
    }

    private func updatePersonalizedLeaderboard(isRetryAttempt: Bool = false, completion: @escaping (Error?) -> Void = { _ in }) {
        viewModel.retrievePersonalizedLeaderboard(completion: { [weak self] (viewModels, personalizedLeaderboard, error) in
            self?.dashboardCards = viewModels ?? []
            self?.loadingView?.removeFromSuperview()
            if let error = error {
                guard let navView = self?.navigationController?.view else {
                    return
                }
                // If retrying, let the error view know that request failed again.
                if isRetryAttempt {
                    completion(error)
                } else {
                    switch error {
                    case APIError.forceUpdate(title: let title, message: let message, storeLink: let storeLink):
                        KillSwitchManager.hideWindow()
                        KillSwitchManager.showForceUpdateAlert(title: title, message: message, storeLink: storeLink)
                    case APIError.inactive(title: let title, message: let message):
                        FullscreenErrorView.presentWindow(title: title, message: message, onTap: { [weak self] retry in
                            self?.updatePersonalizedLeaderboard(isRetryAttempt: true, completion: retry)
                        })
                    default:
                        FullscreenErrorView.cover(navView, onTap: { retry in
                            KillSwitchManager.hideWindow()
                            self?.updatePersonalizedLeaderboard(isRetryAttempt: true, completion: retry)
                        })
                    }
                }
            } else if let personalizedLeaderboard = personalizedLeaderboard {
                KillSwitchManager.hideWindow()
                self?.personalizedLeaderboard = personalizedLeaderboard
                if self?.personalizedLeaderboard?.isInvalid == true {
                    CrashlyticsIntegration.shared.log(event: .gotInvalidPersonalizedLeaderboard)
                }
                self?.updateAccountView()
                completion(nil)
            }
            self?.loadFollowAnAthleteView()
            self?.logAnalytics(with: personalizedLeaderboard)
            self?.refreshView()
            self?.collectionView.reloadData()
        })
    }

    private func logAnalytics(with personalizedLeaderboard: PersonalizedLeaderboard?) {
        let properties = UserAnalyticsProperties(personalizedLeaderboard: personalizedLeaderboard)
        Simcoe.setUserAttributes(properties.rawValue)
        CrashlyticsIntegration.shared.setUserId((personalizedLeaderboard?.competitorId).flatMap(String.init))
    }

    private func refreshView() {
        collectionView.reloadData()

        if UserDefaultsManager.shared.getValue(byKey: .coachMarkTapped) == nil && !dashboardCards.isEmpty {
            coachMark.isHidden = false
            coachMark.play()
        } else {
            coachMark.isHidden = true
        }
        pageControl.numberOfPages = dashboardCards.count
        pageControl.currentPage = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        offsetVisibleCells()
        registerForOpenView.isHidden = !viewModel.canRegisterForOpen
    }

    private func offsetVisibleCells() {
        let visibleCells = collectionView.indexPathsForVisibleItems.sorted().flatMap { collectionView.cellForItem(at: $0) as? DashboardCardCell }

        visibleCells.forEach { element in
            let relativePosition = element.convert(CGPoint.zero, to: view)
            let dx = relativePosition.x
            element.translationFactor = max(-animationSafeRegion, min(dx, animationSafeRegion)) / (animationSafeRegion)
        }
    }

    private func updateAccountView() {
        accountImageView.layer.cornerRadius = accountImageView.frame.width / 2
        accountImageView.layer.masksToBounds = true
        accountTitleLabel.text = viewModel.accountTitle
        accountSubtitleLabel.text = viewModel.accountSubtitle
        let placeholderImage = UIImage(named: "dashboardOutline")
        if let imageURL = (personalizedLeaderboard?.profilePicS3key).flatMap(URL.init) {
            accountImageView.af_setImage(withURL: imageURL, placeholderImage: placeholderImage)
        } else {
            accountImageView.image = placeholderImage
        }
        accountSubtitleLabel.column = (viewModel.isLoggedIn ? 5 : 2)
    }

    private func trackCardExpandedEvent(withTitle title: String?) {
        guard let title = title else {
            return
        }
        Simcoe.track(event: .dashboardCardExpanded,
                     withAdditionalProperties: [.dashboardCard: title], on: .dashboard)
    }

    private func trackAppShareEvent() {
        Simcoe.track(event: .appShare,
                     withAdditionalProperties: [:], on: .dashboard)
    }

    @IBAction private func tappedJoinCompetitionView() {
        Simcoe.track(event: .openRegistration,
                     withAdditionalProperties: [:], on: .dashboard)
        if let url = viewModel.openRegistrationURL {
            let safariViewController = SFSafariBuilder(url: url).build()
            safariViewController.modalPresentationStyle = .overFullScreen
            present(safariViewController, animated: true)
        }
    }

    @IBAction private func tappedShareView(_ sender: UITapGestureRecognizer) {
        guard let url = viewModel.appShareURL else {
            return
        }

        trackAppShareEvent()

        let activityVC = UIActivityViewController(activityItems:
            [dashboardLocalization.appShareURL(url: url.absoluteString)],
                                                  applicationActivities: nil)
        activityVC.excludedActivityTypes = []
        present(activityVC, animated: true, completion: nil)
    }

    @IBAction private func tappedAccountLogin(_ sender: UITapGestureRecognizer) {
        if !viewModel.isLoggedIn {
            animateToHomeScreen()
        }
    }

    @IBAction private func tappedAccountGearIcon(_ sender: UITapGestureRecognizer) {
        Simcoe.track(event: .settingsNavigation,
                     withAdditionalProperties: [:], on: .settings)
        let accountViewController = AccountBuilder().build()
        navigationController?.pushViewController(accountViewController, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - UICollectionViewDataSource
extension DashboardViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showingUnregisteredState || showingFailureState ? 1 : dashboardCards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if showingUnregisteredState {
            gameImageView.isHidden = true
            let cell: EmptyDashboardCell = collectionView.dequeueCell(forIndexPath: indexPath)
            cell.didTapRegister = tappedJoinCompetitionView
            return cell
        } else if showingFailureState {
            let cell: DashboardFailureCell = collectionView.dequeueCell(forIndexPath: indexPath)
            return cell
        }
        let card = dashboardCards[indexPath.item]
        let cell: DashboardCardCell = collectionView.dequeueCell(forIndexPath: indexPath)

        gameImageView.isHidden = false

        cell.divisionName = card.customNameFirstLine.appending(card.customNameSecondLine.flatMap { "\n\($0)" } ?? "")
        if let numberOfAthletes = card.numberOfAthletes {
            cell.maxRank = numberOfAthletes.format()
        } else {
            cell.maxRank = nil
        }

        cell.rankName = localization.overallRank.capitalized
        cell.userRank = Int(card.rank) != nil ? Int(card.rank)?.format() : "1"
        cell.year = String(card.year)
        cell.translationFactor = 0
        cell.backgroundImage = card.backgroundImage

        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension DashboardViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIApplication.shared.keyWindow?.bounds.width ?? 0,
                      height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaultsManager.shared.setValue(withKey: .coachMarkTapped, value: true)
        coachMark.isHidden = true

        guard dashboardCards.count > indexPath.item
            && personalizedLeaderboard?.isInvalid != true else {
                return
        }

        var viewControllers = [UIViewController]()
        for i in 0..<dashboardCards.count {
            let statsCard = dashboardCards[i]
            let dashboardStatsViewController = DashboardStatsBuilder(viewModel: statsCard).build()
            viewControllers.append(dashboardStatsViewController)
        }

        let viewModel = CardDetailContainerViewModel(viewControllers: viewControllers, initialViewIndex: indexPath.item)
        let viewController = CardDetailContainerBuilder(viewModel: viewModel).build()
        containerViewController = (viewController as? CardDetailContainerViewController)

        trackCardExpandedEvent(withTitle: containerViewController?.viewModel.viewControllers[viewModel.initialViewIndex].title)

        navigationController?.pushViewController(viewController, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(round(collectionView.contentOffset.x / collectionView.bounds.width))
        offsetVisibleCells()
    }

}

// MARK: - SponsorViewDelegate
extension DashboardViewController: SponsorViewDelegate {
    
    func tappedLogo(url: URL) {
        let safariViewController = SFSafariBuilder(url: url).build()
        safariViewController.modalPresentationStyle = .overFullScreen
        present(safariViewController, animated: true)
    }
    
}

// MARK: - TabBarTappable
extension DashboardViewController: TabBarTappable {

    func handleTabBarTap() {
        scrollView.setContentOffset(.zero, animated: true)
    }

}
