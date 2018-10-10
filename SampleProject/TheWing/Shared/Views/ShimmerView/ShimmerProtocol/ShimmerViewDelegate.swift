//
//  ShimmerViewDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 9/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Shimmer

protocol ShimmerViewDelegate: class {

    /// View to add a shimmer to.
    var view: UIView { get }

    /// Called when the view is about to apply the shimmer.
    func prepareForShimmer()

    /// Called when the view is about to remove the shimmer.
    func willRemoveShimmer()

    /// Adds a shimmer view to the view provided.
    ///
    /// - Parameter shimmerColor: The color of the shimmer.
    func addShimmerView(withColor shimmerColor: UIColor)
    
}
