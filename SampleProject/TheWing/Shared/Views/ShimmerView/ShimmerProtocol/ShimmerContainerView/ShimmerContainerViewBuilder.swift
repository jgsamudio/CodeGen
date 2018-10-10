//
//  ShimmerContainerViewBuilder.swift
//  TheWing
//
//  Created by Jonathan Samudio on 9/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Shimmer

final class ShimmerContainerViewBuilder {

    // MARK: - Public Functions

    /// Generates the label container view with the parameters provided.
    ///
    /// - Parameters:
    ///   - style: Style of the label.
    ///   - backgroundColor: Color of the shimmer view.
    /// - Returns: Container view.
    static func build(style: ShimmerStyle, backgroundColor: UIColor) -> UIView {
        switch style {
        case .multi(let sections, let spacing):
            return MultiShimmerContainerView(sections: sections, spacing: spacing, backgroundColor: backgroundColor)
        default:
            return build(backgroundColor: backgroundColor)
        }
    }

    /// Generates an shimmer view with the content view customized with the parameters provided.
    ///
    /// - Parameters:
    ///   - image: Image to set the content view to.
    ///   - backgroundColor: Color of the background content view.
    /// - Returns: Shimmer view that has shimmering enabled.
    static func build(image: UIImage? = nil, backgroundColor: UIColor) -> UIView {
    
    // MARK: - Public Properties
    
        let shimmerView = FBShimmeringView()
        var contentView: UIView

        if let image = image {
            let imageView = ImageShimmerContainerView(image: image)
            imageView.contentMode = .center
            contentView = imageView
        } else {
            contentView = ShimmerContainerView()
            contentView.backgroundColor = backgroundColor
        }

        shimmerView.contentView = contentView
        contentView.autoPinEdgesToSuperviewEdges()
        shimmerView.isShimmering = true
        return shimmerView
    }

}
