//
//  LeaderboardResultPrefetchController.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/2/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Table view prefetching data source for leaderboard results.
final class LeaderboardResultPrefetchController: NSObject, UITableViewDataSourcePrefetching {

    private let leaderboardListService: LeaderboardListService

    private let leaderboard: CustomLeaderboard

    /// Set that will be checked whether or not a page is already downloading (and therefor shouldn't be downloaded again).
    private var newLoadingPages: Set<Int> = Set()

    /// Variable indicating whether an error was shown from prefetching.
    /// - Receiving an error and showing a banner will set this to true.
    /// - While true, no banners will be shown when receiving an error.
    /// - Retrying a request via the presented banner will set this to false.
    /// - Loading a response successfully by scrolling to another page will set this to false.
    private var presentedErrorFromPrefetching = false

    init(leaderboard: CustomLeaderboard, leaderboardListService: LeaderboardListService) {
        self.leaderboard = leaderboard
        self.leaderboardListService = leaderboardListService
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let pageIndex = leaderboardListService.pageIndex(for: indexPath.row, in: leaderboard),
                leaderboardListService.athlete(for: leaderboard, atIndex: indexPath.row) == nil,
                !newLoadingPages.contains(pageIndex) {
                newLoadingPages.insert(pageIndex)
                leaderboardListService.getLeaderboardList(with: leaderboard,
                                                          searchCondition: .page(pageIndex: pageIndex),
                                                          completion: { [weak self, weak tableView] (_, error) in
                                                            self?.newLoadingPages.remove(pageIndex)
                                                            // If error: show error banner but only allow loading any page again if
                                                            // the user taps on the banner or scrolls to another page. Otherwise,
                                                            /// scrolling in airplane mode (or  without internet) will keep pushing banners.
                                                            if error != nil {
                                                                if self?.presentedErrorFromPrefetching == false {
                                                                    BannerManager.showError {
                                                                        if let tableView = tableView {
                                                                            self?.presentedErrorFromPrefetching = false
                                                                            self?.tableView(tableView, prefetchRowsAt: indexPaths)
                                                                        }
                                                                    }
                                                                    self?.presentedErrorFromPrefetching = true
                                                                }
                                                            // Otherwise: Continue.
                                                            } else {
                                                                self?.presentedErrorFromPrefetching = false
                                                                tableView?.reloadData()
                                                            }
                })
            }
        }
    }

}
