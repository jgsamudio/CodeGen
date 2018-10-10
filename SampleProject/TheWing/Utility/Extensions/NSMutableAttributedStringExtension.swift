//
//  NSMutableAttributedStringExtension.swift
//  TheWing
//
//  Created by Luna An on 8/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    // MARK: - Public Functions
    
    /// Add attributes to specified text.
    ///
    /// - Parameters:
    ///   - attrs: Attributes to add.
    ///   - text: Text in effect.
    func addAttributes(_ attrs: [NSAttributedStringKey: Any], text: String?) {
        guard let text = text, !text.isEmpty else {
            return
        }
        
        if let regex = try? NSRegularExpression(pattern: text, options: .caseInsensitive) {
    
    // MARK: - Public Properties
    
            let range = NSRange(location: 0, length: string.count)
            for match in regex.matches(in: string,
                                       options: NSRegularExpression.MatchingOptions(),
                                       range: range) as [NSTextCheckingResult] {
                                        addAttributes(attrs, range: match.range)
            }
        }
    }
    
}
