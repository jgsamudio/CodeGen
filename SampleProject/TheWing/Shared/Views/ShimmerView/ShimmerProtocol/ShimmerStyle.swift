//
//  ShimmerStyle.swift
//  TheWing
//
//  Created by Jonathan Samudio on 9/24/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

private typealias Range = (lowerBounds: Int, upperBounds: Int)

/// Shimmer style to be used with labels.
///
/// - short: Short shimmer width.
/// - medium: Medium shimmer width.
/// - long: Long shimmer width.
/// - full: Full shimmer width, matches the view's width.
/// - multi: Multiple shimmer sections.
/// - custom: Custom width to set the shimmer view to.
enum ShimmerStyle {
    case short
    case medium
    case long
    case full
    case multi(sections: Int, spacing: CGFloat)
    case custom(CGFloat)

    // MARK: - Initialization
    
    /// Initializes the style with the raw value provided.
    ///
    /// - Parameter rawValue: Index to match to a size.
    init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .short
        case 1:
            self = .medium
        case 2:
            self = .long
        default:
            return nil
        }
    }

    // MARK: - Public Functions
    
    /// Randomly generates an array of styles with size: short, medium and long.
    ///
    /// - Parameter count: Number of styles to generate.
    /// - Returns: Randomly generated array of styles
    static func randomStyles(count: Int) -> [ShimmerStyle] {
    
    // MARK: - Public Properties
    
        var styleArray = [ShimmerStyle]()

        for _ in 0..<count {
            let rawValue = random(range: Range(0, 2))
            if let style = ShimmerStyle(rawValue: rawValue) {
                styleArray.append(style)
            }
        }

        return styleArray
    }

    /// Multiplier to set the shimmer view width to.
    var widthMultiplier: CGFloat? {
        switch self {
        case .short:
            return 0.333
        case .medium:
            return 0.5
        case .long:
            return 0.666
        case .custom:
            return nil
        default:
            return 1
        }
    }

}

// MARK: - Private Functions
private extension ShimmerStyle {

    static func random(range: Range) -> Int {
        guard range.lowerBounds <= range.upperBounds else {
            return range.lowerBounds
        }
        let endRange = range.upperBounds - range.lowerBounds
        return Int(arc4random_uniform(UInt32(endRange))) + range.lowerBounds
    }

}
