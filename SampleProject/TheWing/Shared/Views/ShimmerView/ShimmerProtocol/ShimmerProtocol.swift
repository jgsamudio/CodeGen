//
//  ShimmerProtocol.swift
//  TheWing
//
//  Created by Jonathan Samudio on 9/24/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Shimmer
import UIKit

protocol ShimmerProtocol {

    /// Views that will be covered by a single shimmer view.
    var shimmerViews: [ShimmerView] { get }

    /// ImageViews that will be covered by a single shimmer view and have an option of applying a shimmer image.
    var shimmerImageViews: [ShimmerImageView] { get }

    /// Color of the shimmer.
    var shimmerColor: UIColor { get }

    /// Views that should be hidden when the view is shimmering.
    var hiddenViews: [UIView] { get }

    /// FBShimmerViews that should be ignored when removing shimmer views from the view.
    var ignoredFBShimmerViews: [UIView] { get }

    /// Applys the shimmer to the views specified above and starts shimmering subviews that conform to ShimmerProtocol.
    ///
    /// - Parameter shimmering: Deternmines if the view should apply the shimmer or remove it.
    func startShimmer(_ shimmering: Bool)

}

extension ShimmerProtocol where Self: UIView {

    // MARK: - Public Properties
    
    var shimmerViews: [ShimmerView] {
        return []
    }

    var shimmerImageViews: [ShimmerImageView] {
        return []
    }

    var shimmerColor: UIColor {
        return UIColor.lightGray
    }

    var hiddenViews: [UIView] {
        return []
    }

    var ignoredFBShimmerViews: [UIView] {
        return []
    }

    // MARK: - Public Functions
    
    func startShimmer(_ shimmering: Bool) {
        isUserInteractionEnabled = !shimmering
        if shimmering {
            applyShimmerToViews()
            applyShimmerToSubviews(shimmering, subviews: subviews)
            hiddenViews.forEach { $0.isHidden = true }
        } else {
            hiddenViews.forEach { $0.isHidden = false }
            removeShimmer(subviews)
        }
    }

}

// MARK: - UIView
// MARK: - Private Functions
private extension ShimmerProtocol where Self: UIView {

    var shimmerViewDelegates: [ShimmerViewDelegate] {
        return shimmerImageViews.compactMap { $0 as ShimmerViewDelegate } +
            shimmerViews.compactMap { $0 as ShimmerViewDelegate }
    }

    func applyShimmerToViews() {
        for shimmerView in shimmerViewDelegates {
            shimmerView.prepareForShimmer()
            guard !viewContainsShimmerView(shimmerView.view) else {
                continue
            }
            shimmerView.addShimmerView(withColor: shimmerColor)
        }
    }

    func applyShimmerToSubviews(_ shimmering: Bool, subviews: [UIView]) {
        for subview in subviews {
            if let shimmerView = subview as? ShimmerProtocol {
                shimmerView.startShimmer(shimmering)
            } else if !(shimmerViewDelegates.map { $0.view }.contains(subview)) {
                applyShimmerToSubviews(shimmering, subviews: subview.subviews)
            }
        }
    }

    func removeShimmer(_ subviews: [UIView]) {
        shimmerViewDelegates.forEach { $0.willRemoveShimmer() }
        for subview in subviews {
            if let shimmerView = subview as? ShimmerProtocol {
                shimmerView.startShimmer(false)
            } else if let viewDelegate = subview as? ShimmerViewDelegate {
                viewDelegate.willRemoveShimmer()
            } else if (subview is FBShimmeringView || subview is ShimmerContainerProtocol)
                && !ignoredFBShimmerViews.contains(subview) {
                subview.removeFromSuperview()
            } else {
                removeShimmer(subview.subviews)
            }
        }
    }

    func viewContainsShimmerView(_ view: UIView) -> Bool {
        return view.subviews.contains(where: {
            $0 is FBShimmeringView || viewContainsShimmerView($0)
        })
    }

}
