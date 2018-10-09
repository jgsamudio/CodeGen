//
//  WorkoutLoaderViewController.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/17/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

private enum WorkoutLoaderCellIndexPath {
    case small
    case large
}

final class WorkoutLoaderViewController: UIViewController {

    @IBOutlet private weak var shimmerView: UIView!
    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var tableViewTopConstraint: NSLayoutConstraint!

    // This is the height of the shrinkableTopView on `WorkoutsViewController`,
    // and is static specifically during the `WorkoutLoaderViewController` state.
    internal static var shrinkableTopViewHeight: CGFloat = 46.0

    internal var headerHeight: CGFloat = 0.0 {
        didSet {
            tableViewTopConstraint.constant = headerHeight
        }
    }

    private let cellList: [WorkoutLoaderCellIndexPath] = [.small, .large, .small, .large, .large]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.isUserInteractionEnabled = false
        shimmerView.startShimmer()
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension WorkoutLoaderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellList[indexPath.row] {
        case .small:
            let cell: WorkoutSmallLoaderTableViewCell = tableView.dequeueCell(forIndexPath: indexPath)
            return cell
        case .large:
            let cell: WorkoutLargeLoaderTableViewCell = tableView.dequeueCell(forIndexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellList.count
    }
}
