//
//  MultiShimmerContainerView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 9/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class MultiShimmerContainerView: UIView, ShimmerContainerProtocol {

    // MARK: - Initialization
    
    /// Initializes a sectioned shimmer view.
    ///
    /// - Parameters:
    ///   - sections: Number of sections to display.
    ///   - spacing: Spacing between each section.
    ///   - backgroundColor: Color of the shimmer content view.
    /// - Returns: Container view.
    init(sections: Int, spacing: CGFloat, backgroundColor: UIColor) {
        super.init(frame: .zero)
    
    // MARK: - Public Properties
    
        let styles = ShimmerStyle.randomStyles(count: sections)
        let totalMultipler = max(styles.compactMap { $0.widthMultiplier }.reduce(0, +), 1)

        let views = styles.map { (style) -> UIView in
            let view = ShimmerContainerViewBuilder.build(backgroundColor: backgroundColor)
            addSubview(view)
            let multiplier = (style.widthMultiplier ?? 0) / totalMultipler
            view.autoMatch(.width, to: .width, of: self, withMultiplier: multiplier)
            view.autoPinEdge(.top, to: .top, of: self)
            view.autoPinEdge(.bottom, to: .bottom, of: self)
            return view
        }

        guard let firstView = views.first else {
            return
        }
        firstView.autoPinEdge(.leading, to: .leading, of: self)

        for index in 0..<views.count-1 {
            let view = views[index]
            let nextView = views[index+1]
            view.autoPinEdge(.trailing, to: .leading, of: nextView, withOffset: -spacing)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
