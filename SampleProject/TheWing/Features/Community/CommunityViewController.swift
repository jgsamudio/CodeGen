//
//  CommunityViewController.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class CommunityViewController: TabBarItemViewController {

	// MARK: - Public Properties

    // MARK: - Public Properties
    
    /// Community view model.
    var viewModel: CommunityViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.registerCell(cellClass: MemberMatchesTableViewCell.self)
        tableView.registerCell(cellClass: MemberTableViewCell.self)
        tableView.registerCell(cellClass: NoResultsTableViewCell.self)
        tableView.registerHeaderFooterView(CommunitySectionHeader.self)
        tableView.registerHeaderFooterView(MemberSearchSegmentedSectionHeader.self)
        tableView.estimatedSectionHeaderHeight = 100
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
    
    // MARK: - Public Functions

    override func tabBarItemTitle() -> String {
        return "COMMUNITY_TAB_TITLE".localized(comment: "Community")
    }

    override func tabBarIcon() -> (selected: UIImage?, unselected: UIImage?) {
        return (#imageLiteral(resourceName: "community-active"), #imageLiteral(resourceName: "community-inactive"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        viewModel.loadMembers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.resyncCommunityPage()
    }

}

// MARK: - Private Functions
private extension CommunityViewController {
    
    func setupDesign() {
        view.backgroundColor = colorTheme.invertPrimary
        setupTableView()
        setupPullToRefresh()
        view.isUserInteractionEnabled = false
    }

    func setLoadingIndicator(loading: Bool) {
        if !loading {
            refreshControlView.setIsLoading(loading, scrollView: tableView)
        }
        activityIndicator.isLoading(loading: loading)
        tableView.tableFooterView = loading && !viewModel.isNoResultActive ? activityIndicator : nil
    }

    func setupTableView() {
        view.insertSubview(tableView, belowSubview: headerView)
        tableView.autoPinEdgesToSuperviewEdges(excludingEdge: .top)
        tableView.autoPinEdge(.top, to: .bottom, of: headerView)
    }
    
    func setupPullToRefresh() {
        view.insertSubview(refreshControlView, belowSubview: tableView)
        refreshControlView.autoPinEdge(.top, to: .bottom, of: headerView)
        refreshControlView.autoPinEdge(.leading, to: .leading, of: view)
        refreshControlView.autoPinEdge(.trailing, to: .trailing, of: view)
    }

    func pushMemberProfile(memberInfo: MemberInfo) {
        let viewController = builder.profileViewController(userId: memberInfo.userId, partialMemberInfo: memberInfo)
        analyticsProvider.track(event: AnalyticsEvents.Community.didSelectProfile.analyticsIdentifier,
                                properties: memberInfo.analyticsProperties(forScreen: self),
                                options: nil)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - MembersViewDelegate
extension CommunityViewController: MembersViewDelegate {
    
    func didReset() {
        view.isUserInteractionEnabled = false
    }

    func refreshView() {
        tableView.reloadData()
        view.layoutIfNeeded()
    }
    
    func loading(_ isLoading: Bool) {
        (headerView as? FilterSearchTabHeaderView)?.searchBar.isUserInteractionEnabled = !isLoading
        setLoadingIndicator(loading: isLoading)
        if !isLoading {
            UIView.animate(withDuration: AnimationConstants.defaultDuration) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableView.alpha = 1
                strongSelf.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func setFilterCount(_ count: Int) {
        (headerView as? FilterSearchTabHeaderView)?.setFilterCount(count)
    }

    func search(_ searchText: String?) {
        viewModel.searchText = searchText
        if viewModel.memberSearchCategory == .unfiltered {
            viewModel.filterMembers(category: .all)
        } else {
            viewModel.filterMembers(category: viewModel.memberSearchCategory)
        }
    }
    
    func displayAllMembers() {
        viewModel.filterMembers(category: .unfiltered)
    }
    
}

// MARK: - UITableViewDataSource
extension CommunityViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CommunitySection.all.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let communitySection = CommunitySection(rawValue: section) else {
            return 0
        }
        return viewModel.memberCount(in: communitySection)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let communitySection = CommunitySection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        let noResultsCell: NoResultsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let cell: MemberTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        switch (communitySection, viewModel.memberSearchCategory) {
        case (.topMatches, .unfiltered):
            let cell: MemberMatchesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setup(title: CommunityLocalization.topMatches,
                       buttonTitle: viewModel.topMatchesSectionHeaderTitle,
                       dataSourcesCount: viewModel.matchesMemberInfo.count,
                       delegate: self,
                       theme: theme,
                       isLoading: viewModel.isInitialLoad)
            return cell
        case (.topMatches, .all), (.topMatches, .asks), (.topMatches, .offers):
            return UITableViewCell()
        default:
            if viewModel.isNoResultActive {
                noResultsCell.setup(theme: theme, delegate: self)
                return noResultsCell
            }
            cell.setup(theme: theme,
                       memberInfo: viewModel.memberInfo[safe: indexPath.row],
                       category: viewModel.memberSearchCategory,
                       isLoading: viewModel.isInitialLoad)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let communitySection = CommunitySection(rawValue: section) else {
            return nil
        }
        
        switch (communitySection, viewModel.memberSearchCategory) {
        case (.topMatches, _):
            return nil
        case (.other, .unfiltered):
            let header: CommunitySectionHeader = tableView.dequeueReusableHeaderFooterView()
            header.setup(theme: theme, title: viewModel.title, isLoading: viewModel.isInitialLoad)
            return header
        default:
            let header: MemberSearchSegmentedSectionHeader = tableView.dequeueReusableHeaderFooterView()
            header.setup(theme: theme,
                         count: viewModel.totalMemberCount ?? viewModel.memberInfo.count,
                         selectedSegmentIndex: viewModel.memberSearchCategory.rawValue,
                         delegate: self)
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let communitySection = CommunitySection(rawValue: section) else {
            return .leastNonzeroMagnitude
        }
        
        switch communitySection {
        case .topMatches:
            return .leastNonzeroMagnitude
        default:
            return UITableViewAutomaticDimension
        }
    }

}

// MARK: - UITableViewDelegate
extension CommunityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memberInfo = viewModel.memberInfo[safe: indexPath.row] else {
            return
        }

        if let currentUser = currentUser, currentUser.userId == memberInfo.userId {
            let properties =  [
                AnalyticsConstants.ProfileCTA.key: AnalyticsConstants.ProfileCTA.memberCell.analyticsIdentifier
            ]
            analyticsProvider.track(event: AnalyticsEvents.Profile.profileClicked.analyticsIdentifier,
                                    properties: properties,
                                    options: nil)
        } else {
            let analyticsProperties = memberInfo.analyticsProperties(forScreen: self, andAdditionalProperties: [
                AnalyticsConstants.ProfileCTA.key: AnalyticsConstants.ProfileCTA.memberCell.analyticsIdentifier
            ])
            analyticsProvider.track(event: AnalyticsEvents.Community.didSelectProfile.analyticsIdentifier,
                                    properties: analyticsProperties,
                                    options: nil)
        }
        
        pushMemberProfile(memberInfo: memberInfo)
    }
    
}

// MARK: - FilterSearchTabHeaderViewDelegate
extension CommunityViewController: FilterSearchTabHeaderViewDelegate {

    func animateHeaderConstraints(with offset: CGFloat) {
        headerViewTopConstraint?.constant = offset
        animateConstraints()
    }

    func filterButtonSelected() {
        present(builder.filtersViewController(filtersDelegate: viewModel), animated: true, completion: nil)
    }
    
    func displaySearchResult(with searchText: String?) {
        viewModel.search(searchText)
    }
    
    func cancelSearch() {
        tableView.setContentOffset(.zero, animated: false)
        viewModel.search(nil)
    }

}

// MARK: - UIScrollViewDelegate
extension CommunityViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshControlView.scrollViewDidScroll(scrollView)
        if scrollView.scrolledPastThreshold(ViewConstants.paginateScrollPercentage) {
            if !viewModel.isNoResultActive {
                viewModel.loadMembers()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshControlView.scrollViewDidEndDragging(scrollView)
    }

}

// MARK: - MembersSearchSegmentedViewDelegate
extension CommunityViewController: MembersSearchSegmentedViewDelegate {
    
    func segmentedItemSelected(category: MemberSearchCategory) {
        viewModel.filterMembers(category: category)
    }
    
}

// MARK: - AnalyticsIdentifiable
extension CommunityViewController: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.community.analyticsIdentifier
    }

}
    
// MARK: - NoResultDelegate
extension CommunityViewController: NoResultDelegate {
    
    func refineFiltersSelected() {
        headerView.resetSearchField(hasSearchText: viewModel.searchText?.nilIfEmpty != nil)
        viewModel.resetSearchAndFilter()
    }

}

// MARK: - CarouselSectionViewDelegate
extension CommunityViewController: CarouselSectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.topMatchesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MemberMatchCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(memberInfo: viewModel.matchesMemberInfo[safe: indexPath.row],
                   theme: theme,
                   isLoading: viewModel.isInitialLoad)
        return cell
    }
    
    func didSelectAction() {
        let viewController = builder.topMatchesViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        pushMemberProfile(memberInfo: viewModel.matchesMemberInfo[indexPath.row])
    }
    
}

// MARK: - RefreshControlDelegate
extension CommunityViewController: RefreshControlDelegate {
    
    func reload() {
        refreshControlView.setIsLoading(true, scrollView: tableView)
        viewModel.reset()
        tableView.reloadData()
    }
    
}
