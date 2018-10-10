//
//  StyleRow.swift
//  StyleGuide
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import UIKit

/// Denotes the row attribute of the Ying grid's style guide
/// Changes the font attributes of text/title
enum StyleRow: Int {
    case r1 = 1
    case r2
    case r3
    case r4
    case r5
    case r6
    case r7
    case r8
    case r9
    case r10
    case r11
    case r12
    case r13
    case r14
    case r15
    case r16
    case r17
    case r18
    case r19
    case r20

    // MARK: - Public Properties
    
    var attributes: [NSAttributedStringKey: Any] {
        return [NSAttributedStringKey.paragraphStyle: paragraphStyle,
                NSAttributedStringKey.kern: kerning]
    }

    var rawAttributes: [String: Any] {
        return [NSAttributedStringKey.paragraphStyle.rawValue: paragraphStyle,
                NSAttributedStringKey.kern.rawValue: kerning]
    }

    var fontFamily: String {
        switch self {
        case .r19, .r20:
            return "Raleway"
        default:
            return "Ubuntu"
        }
    }

    var fontSize: CGFloat {
        let dynamicFontSizeFactor = UIContentSizeCategory.large //UIApplication.shared.preferredContentSizeCategory

        let factor: CGFloat
        switch dynamicFontSizeFactor {
        // Accessibility
        case UIContentSizeCategory.accessibilityExtraExtraExtraLarge:
            factor = 5
        case UIContentSizeCategory.accessibilityExtraExtraLarge:
            factor = 4
        case UIContentSizeCategory.accessibilityExtraLarge:
            factor = 3
        case UIContentSizeCategory.accessibilityLarge:
            factor = 2
        case UIContentSizeCategory.accessibilityMedium:
            factor = 1
        // Default
        case UIContentSizeCategory.extraExtraExtraLarge:
            factor = 4
        case UIContentSizeCategory.extraExtraLarge:
            factor = 3
        case UIContentSizeCategory.extraLarge:
            factor = 2
        case UIContentSizeCategory.large:
            factor = 1
        case UIContentSizeCategory.medium:
            factor = 0.9
        case UIContentSizeCategory.small:
            factor = 0.8
        case UIContentSizeCategory.extraSmall:
            factor = 0.7
        default:
            factor = 1
        }

        switch self {
        case .r1:
            return 12 * factor
        case .r2:
            return 14 * factor
        case .r3:
            return 16 * factor
        case .r4:
            return 20 * factor
        case .r5:
            return 24 * factor
        case .r6:
            return 28 * factor
        case .r7:
            return 34 * factor
        case .r8:
            return 45 * factor
        case .r9:
            return 56 * factor
        case .r10:
            return 18 * factor
        case .r11:
            return 10 * factor
        case .r12:
            return 70 * factor
        case .r13:
            return 92 * factor
        case .r14:
            return 66 * factor
        case .r15:
            return 76 * factor
        case .r16, .r17, .r18:
            return 10 * factor
        case .r19:
            return 34 * factor
        case .r20:
            return 58 * factor
        }
    }

    // MARK: - Private Properties
    
    private var paragraphStyle: NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        return paragraphStyle
    }

    private var lineSpacing: CGFloat {
        switch self {
        case .r1:
            return 4
        case .r2:
            return 6
        case .r3:
            return 6
        case .r4:
            return 4
        case .r5:
            return 4
        case .r6:
            return 6
        case .r7:
            return 8
        case .r8:
            return 11
        case .r9:
            return 14
        case .r10:
            return 6
        case .r11:
            return 6
        case .r19:
            return 10
        case .r20:
            return 18
        default:
            return 0

        }
    }

    private var kerning: CGFloat {
        switch self {
        case .r1:
            return 0.3
        case .r11:
            return 0.3
        case .r2, .r3, .r4, .r5, .r6, .r7, .r8, .r9, .r10, .r12, .r13, .r14, .r15, .r16, .r17, .r18, .r19, .r20:
            return 0
        }
    }

}
