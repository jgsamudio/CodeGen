//
//  Int+Crossfit.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension Int {

    private static var numberFormatter: NumberFormatter = NumberFormatter()

    /// Fotmats an integer for the specified grouping size
    ///
    /// - Parameter groupingSize: Grouping size
    /// - Returns: Formatted string
    func format(groupedBy groupingSize: Int = 3) -> String? {
        Int.numberFormatter.locale = .autoupdatingCurrent
        Int.numberFormatter.usesGroupingSeparator = true
        Int.numberFormatter.groupingSize = groupingSize
        return Int.numberFormatter.string(for: self)
    }
    
}
