//
//  MembersViewController.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class MembersViewController: BuildableViewController {
    
    // MARK: - Public Properties
    
    var membersProvider: MembersProvider! {
        didSet {
            membersProvider.delegate = self
        }
    }
    
    // MARK: - Private Properties
    
    private var navigationViewTopConstraint: NSLayoutConstraint?
    
    private lazy var navigationView: FilterSearchNavigationView = {
        let navigationView = FilterSearchNavigationView(theme: theme)
        navigationView.backgroundColor = theme.colorTheme.invertTertiary
        navigationView.delegate = self
        navigationView.set(title: membersProvider.title)
        return navigationView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 120
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerCell(cellClass: MemberTableViewCell.self)
        tableView.registerCell(cellClass: NoResultsTableViewCell.self)
        tableView.registerHeaderFooterView(MemberSearchSegmentedSectionHeader.self)
        tableView.estimatedSectionHeaderHeight = 128
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var activityIndicator: LoadingIndicator = {
        let indicator = LoadingIndicator(activityIndicatorViewStyle: .gray)
        indicator.frame = ViewConstants.loadingIndicatorFooterFrame
        return indicator
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

    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        membersProvider.loadMembers()
    }
    
}

// MARK: - Private Functions
private extension MembersViewController {
    
    func setupDesign() {
        view.backgroundColor = colorTheme.invertPrimary
        setupTableView()
        setupNavigationView()
        tableView.isUserInteractionEnabled = false
        navigationView.isUserInteractionEnabled = false
        view.insertSubview(refreshControlView, belowSubview: tableView)
        refreshControlView.autoPinEdge(.top, to: .bottom, of: navigationView)
        refreshControlView.autoPinEdge(.leading, to: .leading, of: view)
        refreshControlView.autoPinEdge(.trailing, to: .trailing, of: view)
    }
    
    func setupNavigationView() {
        view.addSubview(navigationView)
        navigationViewTopConstraint = navigationView.autoPinEdge(toSuperviewEdge: .top)
        navigationView.autoPinEdge(toSuperviewEdge: .leading)
        navigationView.autoPinEdge(toSuperviewEdge: .trailing)
        tableView.autoPinEdge(.top, to: .bottom, of: navigationView)
    }
    
    func setupTableView() {
        view.insertSubview(tableView, belowSubview: navigationView)
        tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }

}

// MARK: - MembersViewDelegate
extension MembersViewController: MembersViewDelegate {
    
    func didReset() {
        refreshControlView.setIsLoading(true, scrollView: tableView)
        tableView.setContentOffset(CGPoint(x: 0, y: -83), animated: true)
        tableView.contentInset.top = 83
        tableView.isUserInteractionEnabled = false
    }

    func setFilterCount(_ count: Int) {
        navigationView.setFilterCount(count)
    }
    
    func loading(_ isLoading: Bool) {
        navigationView.isUserInteractionEnabled = !isLoading
        refreshControlView.setIsLoading(isLoading, scrollView: tableView)
        activityIndicator.isLoading(loading: isLoading)
        tableView.tableFooterView = isLoading && !membersProvider.isNoResultActive ? activityIndicator : nil
        
        if !isLoading {
            UIView.animate(withDuration: AnimationConstants.defaultDuration) {
                self.tableView.isUserInteractionEnabled = true
                self.navigationView.isUserInteractionEnabled = true
            }
        }
    }
    
    func refreshView() {
        tableView.reloadData()
        view.layoutIfNeeded()
    }
    
    func search(_ searchText: String?) {
        membersProvider.searchText = searchText
        if membersProvider.memberSearchCategory == .unfiltered {
            membersProvider.filterMembers(category: .all)
        } else {
            membersProvider.filterMembers(category: membersProvider.memberSearchCategory)
        }
    }
    
    func displayAllMembers() {
        membersProvider.filterMembers(category: .unfiltered)
    }
    
}

// MARK: - FilterSearchNavigationViewDelegate
extension MembersViewController: FilterSearchNavigationViewDelegate {
    
    func backButtonSelected() {
        navigationController?.popViewController(animated: true)
    }
    
    func filterButtonSelected() {
        present(builder.filtersViewController(filtersDelegate: membersProvider),
                animated: true,
                completion: nil)
    }
    
    func animateHeaderConstraints(with offset: CGFloat) {
        navigationViewTopConstraint?.constant = offset
        animateConstraints()
    }
    
    func displaySearchResult(with searchText: String?) {
        membersProvider.search(searchText)
    }
    
    func cancelSearch() {
        membersProvider.search(nil)
    }
    
}

// MARK: - UITableViewDataSource
extension MembersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersProvider.memberCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if membersProvider.isNoResultActive {
            let noResultsCell: NoResultsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            noResultsCell.setup(theme: theme, delegate: self)
            return noResultsCell
        } else {
            let cell: MemberTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setup(theme: theme,
                       memberInfo: membersProvider.memberInfo[safe: indexPath.row],
                       category: membersProvider.memberSearchCategory,
                       isLoading: membersProvider.shouldShowShimmerState)
            return cell
        }
    }
    
}

// MARK: - UITableViewDelegate
extension MembersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memberInfo = membersProvider.memberInfo[safe: indexPath.row] else {
            return
        }
        
        if let currentUser = currentUser, currentUser.userId == memberInfo.userId {
            let properties = [
                AnalyticsConstants.ProfileCTA.key: AnalyticsConstants.ProfileCTA.memberCell.analyticsIdentifier
            ]
            analyticsProvider.track(event: AnalyticsEvents.Profile.profileClicked.analyticsIdentifier,
                                    properties: properties,
                                    options: nil
            )
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch membersProvider.memberSearchCategory {
        case .unfiltered:
            return .leastNonzeroMagnitude
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch membersProvider.memberSearchCategory {
        case .unfiltered:
            return nil
        default:
            let header: MemberSearchSegmentedSectionHeader = tableView.dequeueReusableHeaderFooterView()
            header.setup(theme: theme,
                         count: membersProvider.totalMemberCount ?? membersProvider.memberInfo.count,
                         selectedSegmentIndex: membersProvider.memberSearchCategory.rawValue,
                         delegate: self)
            return header
        }
    }
    
}

// MARK: - UIScrollViewDelegate
extension MembersViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshControlView.scrollViewDidScroll(scrollView)
        if scrollView.scrolledPastThreshold(ViewConstants.paginateScrollPercentage) {
            if !membersProvider.isNoResultActive {
                membersProvider.loadMembers()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshControlView.scrollViewDidEndDragging(scrollView)
    }
    
}

// MARK: - MembersSearchSegmentedViewDelegate
extension MembersViewController: MembersSearchSegmentedViewDelegate {
    
    func segmentedItemSelected(category: MemberSearchCategory) {
        membersProvider.filterMembers(category: category)
    }
    
}

// MARK: - NoResultDelegate
extension MembersViewController: NoResultDelegate {
    
    func refineFiltersSelected() {
        navigationView.reset(hasSearchText: membersProvider.searchText?.nilIfEmpty != nil)
        membersProvider.resetSearchAndFilter()
    }
    
}

// MARK: - AnalyticsIdentifiable
extension MembersViewController: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.members.analyticsIdentifier
    }
    
}

// MARK: - RefreshControlDelegate
extension MembersViewController: RefreshControlDelegate {
    
    func reload() {
        membersProvider.reset()
    }
    
}
