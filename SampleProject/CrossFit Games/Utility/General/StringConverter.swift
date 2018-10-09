//
//  StringConverter.swift
//  CrossFit Games
//
//  Created by Malinka Seneviratne on 10/24/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Tool for generating and manipulating attributed strings.
public struct StringConverter {

    /// Creates an attributed string with the given HTML string. Takes HTML format, such as `<b>Text</b>` into account.
    ///
    /// - Parameters:
    ///   - htmlEncodedString: Plain HTML string, to be parsed as NSAttributedString.
    ///   - usingCSSFontFamily: Font family that should be used to generate the attributed string.
    ///   - lineHeightInPixels: Line height used in the generated attributed string.
    ///   - fontSizeInPixels: Font size used in the generated attributed string.
    /// - Returns: An `NSAttributedString` if parsing worked without issues or nil, if the HTML content couldn't be
    ///   parsed as NSAttributedString.
    public static func attributedString(htmlEncodedString: String,
                                        usingCSSFontFamily: String = "-apple-system",
                                        lineHeightInPixels: Int = 21,
                                        fontSizeInPixels: Int? = nil) -> NSAttributedString? {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] =
            [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html.rawValue,
             NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.unicode.rawValue]
        do {
            let styledHTML = "<span style=\"font-family: \(usingCSSFontFamily);" +
                "line-height: \(lineHeightInPixels)px;\(fontSizeInPixels.flatMap { "font-size: \($0);" } ?? "")\">" +
            "\(htmlEncodedString)</span>"

            if let htmlData = styledHTML.data(using: .unicode) {
                let str = try NSMutableAttributedString(data: htmlData, options: options, documentAttributes: nil)

                for (index, character) in str.string.enumerated().reversed() where character == "✔" {
                    var range: NSRange? = NSRange(location: index, length: 1)
                    // swiftlint:disable force_unwrapping
                    let attributes = str.attributes(at: index, effectiveRange: &range!)
                    let fixedCheckmark = NSAttributedString(string: "✔".escapingCharactersWithVariationSelector0E,
                                                            attributes: attributes)
                    str.replaceCharacters(in: NSRange(location: index, length: 1),
                                          with: fixedCheckmark)
                }

                return NSAttributedString(attributedString: str)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    /// Returns crossfit style attributed text from the given HTML encoded string.
    ///
    /// - Parameter htmlEncodedString: HTML encoded string.
    /// - Returns: String with (R5C4W4) for bold and (R2C4W1) for regular text.
    public static func crossFitStyleHTMLString(htmlEncodedString: String) -> NSAttributedString? {
        guard let content = attributedString(htmlEncodedString: htmlEncodedString) else {
            return nil
        }

        let titleAttributeAdjustment = replace(font: UIFont.boldSystemFont(ofSize: 18),
                                               of: content,
                                               withAttributes: StyleGuide.shared.style(row: .r5, column: .c4, weight: .w4))

        let contentAttributeAdjustment = replace(font: UIFont.systemFont(ofSize: 12),
                                                 of: titleAttributeAdjustment,
                                                 withAttributes: StyleGuide.shared.style(row: .r2, column: .c4, weight: .w1))

        let boldAttributeAdjustment = replace(font: UIFont.boldSystemFont(ofSize: 12),
                                               of: contentAttributeAdjustment,
                                               withAttributes: StyleGuide.shared.style(row: .r2, column: .c4, weight: .w4))

        return boldAttributeAdjustment
    }

    /// Returns the given string, replacing all instances of `font` with `newFont`.
    ///
    /// - Parameters:
    ///   - font: Font to replace.
    ///   - string: Attributed string to operate on.
    ///   - newFont: Font that's replacing the old font.
    /// - Returns: `string` with occurences of `font` replaced with `newFont`.
    public static func replace(font: UIFont,
                               of string: NSAttributedString,
                               with newFont: UIFont) -> NSAttributedString {
        let mutableCopy: NSMutableAttributedString = NSMutableAttributedString(attributedString: string)
        mutableCopy.beginEditing()
        mutableCopy.enumerateAttribute(NSAttributedStringKey.font,
                                       in: NSRange(location: 0, length: string.string.count),
                                       options: []) { (value, range, _) in
                                        if let oldFont = value as? UIFont {
                                            var replacementFont = oldFont
                                            if oldFont == font {
                                                replacementFont = newFont
                                            }
                                            mutableCopy.setAttributes([NSAttributedStringKey.font: replacementFont],
                                                                      range: range)
                                        }
        }
        mutableCopy.endEditing()
        return mutableCopy
    }

    /// Adjusts an attributed string by searching for a font name and replacing the ranges in which this font name
    /// is used with a different set of attributes.
    ///
    /// - Parameters:
    ///   - fontName: Font name to be searched.
    ///   - string: String in which to search.
    ///   - attributes: Attributes to set where the given font name is found.
    /// - Returns: Adjusted attributed string.
    public static func replace(font: UIFont,
                               of string: NSAttributedString,
                               withAttributes attributes: [NSAttributedStringKey: Any]) -> NSAttributedString {
        let mutableCopy: NSMutableAttributedString = NSMutableAttributedString(attributedString: string)
        mutableCopy.beginEditing()
        mutableCopy.enumerateAttribute(NSAttributedStringKey.font,
                                       in: NSRange(location: 0, length: string.string.count),
                                       options: []) { (value, range, _) in
                                        if let oldFont = value as? UIFont, oldFont == font {
                                            mutableCopy.setAttributes(attributes,
                                                                      range: range)
                                        }
        }
        mutableCopy.endEditing()
        return mutableCopy
    }

    /// Adjusts the given text whenever `matching` evaluates to true.
    ///
    /// - Parameters:
    ///   - matching: Callback with a set of attributes of the current substring. Should return true if the
    ///     given attributes meet some criteria.
    ///   - text: Text that should be modified.
    ///   - adjustment: Adjustment on the text.
    /// - Returns: Text adjusted with the provided parameters.
    public static func adjustTextWhen(matching: ([NSAttributedStringKey: Any]) -> Bool,
                                      inText text: NSAttributedString,
                                      adjustment: (String) -> String) -> NSAttributedString {
        let mutableCopy: NSMutableAttributedString = NSMutableAttributedString(attributedString: text)
        mutableCopy.beginEditing()
        mutableCopy.enumerateAttributes(in: NSRange(location: 0, length: text.string.count),
                                        options: []) { (value, range, _) in
                                            if matching(value) {
                                                let replacing = mutableCopy.attributedSubstring(from: range)
                                                mutableCopy.replaceCharacters(in: range,
                                                                              with: adjustment(replacing.string))
                                            }
        }
        mutableCopy.endEditing()
        return mutableCopy
    }

    /// Adds attributes where characters fulfil a certain condition.
    ///
    /// - Parameters:
    ///   - attributes: Attributes to set.
    ///   - condition: Condition to fulfil.
    ///   - attributedString: Attributed string to modify.
    /// - Returns: New attributed string with added attributes.
    public static func setAttributes(attributes: [NSAttributedStringKey: Any],
                                     when condition: (Character) -> Bool,
                                     in attributedString: NSAttributedString) -> NSAttributedString {
        var indices: [Int] = []
        attributedString.string.enumerated().forEach { (index, element) in
            if condition(element) {
                indices.append(index)
            }
        }

        let mutableString = NSMutableAttributedString(attributedString: attributedString)

        for index in indices {
            mutableString.setAttributes(attributes, range: NSRange(location: index, length: 1))
        }

        return mutableString
    }

    static func removeLineSpacing(from string: NSAttributedString) -> NSAttributedString {
        let mutableCopy = NSMutableAttributedString(attributedString: string)

        string.enumerateAttributes(in: NSRange(location: 0, length: string.string.count),
                                   options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attributes, range, _) in
                                    if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
                                        let mutableParagraphStyle = NSMutableParagraphStyle()
                                        mutableParagraphStyle.setParagraphStyle(paragraphStyle)
                                        mutableParagraphStyle.lineSpacing = 0
                                        mutableCopy.addAttributes([NSAttributedStringKey.paragraphStyle: mutableParagraphStyle], range: range)
                                    }
        }

        return mutableCopy
    }

}

public extension String {

    /// Use this to make Apple not convert checkmarks to emoji in UITextView.
    ///
    /// For discussion, see:
    /// - https://paulofierro.com/blog/2013/3/30/disabling-emoji-characters-with-unicode-variants
    /// - https://www.utf8icons.com/subsets/dingbats
    /// - http://www.unicode.org/Public/UNIDATA/StandardizedVariants.html
    /// - https://twitter.com/jasoncodes/status/590356654790574080
    var escapingCharactersWithVariationSelector0E: String {
        var newStr = ""
        for unicodeScalar in unicodeScalars {
            switch unicodeScalar.value {
            case 0x2709, 0x2714, 0x270C, 0x270D, 0x2764, 0x2600, 0x2602, 0x262F, 0x2622, 0x260E, 0x2744:
                var escapedScalar = String(Character(unicodeScalar))
                escapedScalar.append("\u{0000FE0E}")
                newStr.append(escapedScalar)
            default:
                newStr.append(Character(unicodeScalar))
            }
        }

        return newStr
    }

}
