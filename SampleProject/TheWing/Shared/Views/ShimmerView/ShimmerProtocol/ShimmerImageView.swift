//
//  ShimmerImageView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 9/24/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class ShimmerImageView {

    // MARK: - Private Properties

    /// Image view to apply the shimmer.
    private let imageView: UIImageView
    
    /// Image to shimmer when the view is shimmering.
    private let shimmerImage: UIImage?

    /// Original image when the view is shimmering.
    private var originalImage: UIImage?

    // MARK: - Initialization

    /// Default initializer of the shimmer image view.
    ///
    /// - Parameters:
    ///   - imageView: Image view to apply the shimmer to.
    ///   - image: Original image.
    ///   - shimmerImage: Custom shimmer image.
    init(_ imageView: UIImageView, image: UIImage? = nil, shimmerImage: UIImage? = nil) {
        self.imageView = imageView
        self.shimmerImage = shimmerImage
        self.originalImage = image
    }

}

// MARK: - ShimmerViewDelegate
extension ShimmerImageView: ShimmerViewDelegate {

    // MARK: - Public Properties
    
    var view: UIView {
        return imageView
    }

    // MARK: - Public Functions
    
    func prepareForShimmer() {
        imageView.af_cancelImageRequest()
        imageView.isHidden = false
        imageView.image = nil
    }

    func willRemoveShimmer() {
        if let originalImage = originalImage {
            imageView.image = originalImage
        }
    }

    func addShimmerView(withColor shimmerColor: UIColor) {
        let containerView = ShimmerContainerViewBuilder.build(image: shimmerImage, backgroundColor: shimmerColor)
        imageView.addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdges()
    }

}
