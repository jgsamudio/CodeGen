//
//  Math.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/14/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

extension FloatingPoint {

    // MARK: - Public Functions
    
    /// Clamps `self` within `[minimum, maximum]` and returns the result.
    ///
    /// Examples:
    /// - 12.0.clamp(minimum: 13, maximum: 15) // returns 13
    /// - 16.0.clamp(minimum: 13, maximum: 15) // returns 15
    /// - 14.0.clamp(minimum: 13, maximum: 15) // returns 14
    ///
    /// - Parameters:
    ///   - minimum: Minimum value of the result.
    ///   - maximum: Maximum value of the result.
    /// - Returns: The result of `self` clamped into `[minimum, maximum]`
    func clamp(minimum: Self, maximum: Self) -> Self {
        return max(minimum, min(maximum, self))
    }

}

/// Computes the percentile of a rank, given the actual rank and the maximum rank.
///
/// - Parameters:
///   - rank: Rank of an athlete.
///   - maxRank: Maximum rank among all athletes.
/// - Returns: Percentile of the rank.
func percentile(rank: Int, maxRank: Int) -> Int {
    if maxRank == 1 || maxRank == 0 {
        return 99
    } else {
        return Int(((1 - Double(rank)/Double(maxRank)) * 100).rounded(.down))
    }
}
