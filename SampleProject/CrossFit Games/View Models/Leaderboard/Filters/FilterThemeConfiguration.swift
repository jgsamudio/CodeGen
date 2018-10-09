//
//  FilterThemeConfiguration.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Theme configuration to customize UI layout of a filter view controller.
struct FilterThemeConfiguration {

    private static let selectedBlue = UIColor(displayP3Red: 22/255, green: 100/255, blue: 187/255, alpha: 1)
    private static let selectedWhite = UIColor(displayP3Red: 242/255, green: 246/255, blue: 251/255, alpha: 1)

    /// Default blue theme configuration.
    static let blue = FilterThemeConfiguration(titleAttributes: StyleGuide.shared.style(row: .r10, column: .c1, weight: .w4),
                                               largeTitleAttributes: StyleGuide.shared.style(row: .r6, column: .c1, weight: .w4),
                                               optionTitleAttributes: StyleGuide.shared.style(row: .r10, column: .c1, weight: .w2),
                                               selectedOptionCheckmarkTintColor: .white,
                                               selectedBackgroundColor: selectedBlue,
                                               barButtonTintColor: .white,
                                               backgroundColor: StyleColumn.c2.color,
                                               shouldUseLargeTitles: true)

    /// Default blue theme configuration.
    static let white = FilterThemeConfiguration(titleAttributes: StyleGuide.shared.style(row: .r10, column: .c4, weight: .w4),
                                                largeTitleAttributes: StyleGuide.shared.style(row: .r6, column: .c4, weight: .w4),
                                                optionTitleAttributes: StyleGuide.shared.style(row: .r10, column: .c4, weight: .w2),
                                                selectedOptionCheckmarkTintColor: StyleColumn.c2.color,
                                                selectedBackgroundColor: selectedWhite,
                                                barButtonTintColor: StyleColumn.c2.color,
                                                backgroundColor: .white,
                                                shouldUseLargeTitles: false)

    /// Attributes for the title in the navigation bar.
    let titleAttributes: [NSAttributedStringKey: Any]

    /// Attributes for the title in the navigation bar when expanded.
    let largeTitleAttributes: [NSAttributedStringKey: Any]

    /// Attributes for titles of different selectable items.
    let optionTitleAttributes: [NSAttributedStringKey: Any]

    /// Tint color of the selected option checkmark.
    let selectedOptionCheckmarkTintColor: UIColor

    /// Background color of the selected option cell.
    let selectedBackgroundColor: UIColor

    /// Tint color of bar button items.
    let barButtonTintColor: UIColor

    /// Background color of the screen.
    let backgroundColor: UIColor

    /// Indicates whether or not the navigation bar should use large title layout.
    let shouldUseLargeTitles: Bool

}
