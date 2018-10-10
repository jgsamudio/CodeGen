//
//  UICollectionViewExtension.swift
//  TheWing
//
//  Created by Luna An on 3/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    // MARK: - Public Functions
    
    /// Dequeues a reusable collection view cell.
    ///
    /// - Parameter indexPath: The index path.
    /// - Returns: The collection view cell.
    func dequeueReusableCell<T: ReusableView>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Can't dequeue a collection view cell with identifier \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    /// Dequeues a reusable supplementary view.
    ///
    /// - Parameters:
    ///   - kind: String specifying the kind of supplementary view.
    ///   - indexPath: Index path of supplementary view.
    /// - Returns: Collection view reusable view.
    func dequeReusableSupplementaryView<T: ReusableView>(of kind: String, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind,
                                                          withReuseIdentifier: T.reuseIdentifier,
                                                          for: indexPath) as? T else {
            fatalError("Can't dequeue supplementary view with identifier \(T.reuseIdentifier)")
        }
        
        return view
    }
    
    /// Registers the collection view cell with its reuse identifier.
    ///
    /// - Parameters cellClass: The cell class to use.
    func registerCell<T: ReusableView>(cellClass: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    /// Registers the supplementary view with its reuse identifier given the supplementary view kind.
    ///
    /// - Parameters:
    ///   - viewClass: The view class to use.
    ///   - kind: Kind of supplementary view.
    func registerSupplementaryView<T: ReusableView>(viewClass: T.Type, of kind: String) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }
    
}
