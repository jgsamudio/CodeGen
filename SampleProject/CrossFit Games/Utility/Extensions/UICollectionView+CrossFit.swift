//
//  UICollectionView+CrossFit.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/10/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

extension UICollectionView {

    /// Dequeues and returns a specific collection view cell type for the given index path.
    ///
    /// This call crashes the app if the given cell type can not be dequeued for its own class name.
    ///
    /// - Parameter indexPath: Index path for which to dequeue the cell.
    /// - Returns: Collection view cell of the expected type.
    func dequeueCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Unexpected cell type. Expected \(T.self) for identifier \(T.self)")
        }

        return cell
    }

}
