//
//  UITableView+CrossFit.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/18/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

extension UITableView {

    /// Registers list of nib objects containing a cell with the table view under a specified identifier.
    ///
    /// - Parameter cells: List of UITableViewCell types created as nibs to register
    func registerNibForCells(_ cells: [UITableViewCell.Type]) {
        cells.forEach {
            let name = String(describing: $0.self)
            register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        }
    }

    /// Registers for a header or footer in a table view under a specified identifier.
    ///
    /// - Parameter cells: List of UITableViewHeaderFooterView types created as nibs to register
    func registerNibForHeaderFooter(_ views: [UITableViewHeaderFooterView.Type]) {
        views.forEach {
            let name = String(describing: $0.self)
            register(UINib(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: name)
        }
    }

    /// Dequeues and returns a specific table view cell type for the given index path.
    ///
    /// This call crashes the app if the given cell type can not be dequeued for its own class name.
    ///
    /// - Parameter indexPath: Index path for which to dequeue the cell.
    /// - Returns: Table view cell of the expected type.
    func dequeueCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Unexpected cell type. Expected \(T.self) for identifier \(T.self)")
        }

        return cell
    }

    /// Dequeues and returns a specific table view cell type.
    /// This call crashes the app if the given cell type can not be dequeued for its own class name.
    ///
    /// - Returns: Table view cell of the expected type.
    func dequeueCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Unexpected cell type. Expected \(T.self) for identifier \(T.self)")
        }

        return cell
    }

    /// Dequeus and returns a specific header/footer view for the fiven section
    ///
    /// - Parameter section: section number
    /// - Returns: Header/footer view
    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>(forSection section: Int) -> T {
        let cell = dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T ?? T(reuseIdentifier: String(describing: T.self))

        return cell
    }

    // Set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    func layoutFooterView() {
        guard let footerView = tableFooterView else {
            return
        }
        footerView.setNeedsLayout()
        footerView.layoutIfNeeded()
        footerView.frame.size = footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        self.tableFooterView = footerView
    }

    /// Reloads rows in a table view
    /// Fixes table view freezing in non iOS 11 versions
    ///
    /// - Parameter indexPaths: Array of index paths to be reloaded
    func reloadRows(indexPaths: [IndexPath], with animation: UITableViewRowAnimation = .none) {
        if #available(iOS 11.0, *) {
            reloadRows(at: indexPaths, with: animation)
        } else {
            UIView.transition(with: self,
                              duration: 0.1,
                              options: UIViewAnimationOptions.transitionCrossDissolve,
                              animations: {
                                self.reloadData()
            }, completion: nil)
        }
    }

}
