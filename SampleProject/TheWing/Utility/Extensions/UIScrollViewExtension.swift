//
//  UIScrollViewExtension.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

extension UIScrollView {

    // MARK: - Public Properties
    
    /// Shadow opacity of the navigation bar.
    var navigationShadowOpacity: Float {
        let percentage = Float(min(max(0, contentOffset.y) / ViewConstants.navigationBarThreshold, 1))
        return ViewConstants.navigationBarShadowOpacity * percentage
    }

    // MARK: - Public Functions
    
    /// Scrolls the rect to the center of the scrollview.
    ///
    /// - Parameters:
    ///   - rect: Rect or frame to scroll to.
    ///   - animated: Flag to animate the scroll.
    func scrollToCentered(_ rect: CGRect, animated: Bool) {
        let centeredX = rect.origin.x + (rect.width / 2) - (frame.width / 2)
        let centeredY = rect.origin.y + (rect.height / 2) - (frame.height / 2)
        let centeredRect = CGRect(x: centeredX, y: centeredY, width: frame.width, height: frame.height)
        scrollRectToVisible(centeredRect, animated: animated)
    }
    
    /// Boolean function determining if scrollview has scrolled past a given threshold.
    ///
    /// - Parameter percentageThreshold: Threshold percentage.
    /// - Returns: True, if scrolled past, false otherwise.
    func scrolledPastThreshold(_ percentageThreshold: CGFloat) -> Bool {
        let offset = contentOffset.y + bounds.height
        let height = contentSize.height
        let percentage = offset / height
        return percentage > percentageThreshold
    }

}
