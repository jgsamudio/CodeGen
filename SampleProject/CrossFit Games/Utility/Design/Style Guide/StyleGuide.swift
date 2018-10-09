//
//  StyleGuide.swift
//  StyleGuide
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import UIKit

struct StyleGuide {

    // MARK: - Public Properties
    
    static let shared = StyleGuide()

    // MARK: - Public Functions
    
    func style(row: StyleRow, column: StyleColumn, weight: StyleWeight) -> [NSAttributedStringKey: Any] {
        var attributes = row.attributes
        attributes[NSAttributedStringKey.font] = UIFont(name: "\(row.fontFamily)\(weight.fontSuffix)", size: row.fontSize)
        attributes[NSAttributedStringKey.foregroundColor] = column.color
        return attributes
    }

    func style(row: Int, column: Int, weight: Int) -> [NSAttributedStringKey: Any] {
        guard let styleRow = StyleRow(rawValue: row),
            let styleColumn = StyleColumn(rawValue: column),
            let styleWeight = StyleWeight(rawValue: weight) else {
            return [:]
        }

        return style(row: styleRow, column: styleColumn, weight: styleWeight)
    }

    func styleRaw(row: StyleRow, column: StyleColumn, weight: StyleWeight) -> [String: Any] {
        var attributes = row.rawAttributes
        attributes[NSAttributedStringKey.font.rawValue] = UIFont(name: "\(row.fontFamily)\(weight.fontSuffix)", size: row.fontSize)
        attributes[NSAttributedStringKey.foregroundColor.rawValue] = column.color
        return attributes
    }

}
