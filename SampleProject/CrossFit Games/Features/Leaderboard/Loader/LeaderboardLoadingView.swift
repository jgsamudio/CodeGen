//
//  LeaderboardLoadingViewController.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/12/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Displays List of loader cells
final class LeaderboardLoadingView: UIView {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var shimmerView: UIView!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!

    internal var headerHeight: CGFloat = 0.0 {
        didSet {
            headerHeightConstraint.constant = headerHeight
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        tableView.registerNibForCells([LeaderboardResultLoaderTableViewCell.self])
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.isUserInteractionEnabled = false
        shimmerView.startShimmer()
    }

    class func showOn(viewController: UIViewController) -> LeaderboardLoadingView {
        guard let loader: LeaderboardLoadingView = UINib(nibName: String(describing: LeaderboardLoadingView.self), bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? LeaderboardLoadingView else {
                fatalError("Failed to load loading view for leaderboard.")
        }
        addView(loader, to: viewController.view)
        return loader
    }

    private static func addView(_ view: UIView, to otherView: UIView) {
        view.frame = otherView.bounds
        otherView.addSubview(view)
        view.pinToSuperview(top: 0, leading: 0, bottom: 0, trailing: 0)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension LeaderboardLoadingView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeaderboardResultLoaderTableViewCell = tableView.dequeueCell(forIndexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
