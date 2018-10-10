//
//  TappableLabel.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/16/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

// Reference: http://samwize.com/2016/03/04/how-to-create-multiple-tappable-links-in-a-uilabel/

private final class TappableLabelGestureRecognizer: UITapGestureRecognizer {

    // MARK: - Public Functions
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
    
    // MARK: - Public Properties
    
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText ?? NSAttributedString(string: ""))

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let x = (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x
        let y = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        let textContainerOffset = CGPoint(x: x, y: y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer,
                                                            fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}

/// Special label with the capability of recognizing touch interactions on strings specified in `tappableStrings`.
//@IBDesignable
internal class TappableLabel: StyleableLabel {

    @IBInspectable
    var tappableRow: Int = 5

    @IBInspectable
    var tappableColumn: Int = 1

    @IBInspectable
    var tappableWeight: Int = 1

    /// Array of strings that are supposed to be tappable.
    var tappableStrings: [String] = [] {
        didSet {
            applyStyle()
        }
    }

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// Delegate that is notified about the event of a user tapping any of the links in `self`.
    weak var delegate: TappableLabelDelegate?

    // MARK: - Private Properties
    
    private var gestureRecognizer: TappableLabelGestureRecognizer!

    override func awakeFromNib() {
        super.awakeFromNib()

        isUserInteractionEnabled = true
        gestureRecognizer = TappableLabelGestureRecognizer(target: self, action: #selector(tappedLabel))
        addGestureRecognizer(gestureRecognizer)
    }

    @objc private func tappedLabel(_ recognizer: UIGestureRecognizer) {
        guard let recognizer = recognizer as? TappableLabelGestureRecognizer else {
            return
        }

        for string in tappableStrings.enumerated() {
            let rangeOfString = ((text ?? "") as NSString).range(of: string.element)
            guard rangeOfString.location != NSNotFound else {
                continue
            }

            if recognizer.didTapAttributedTextInLabel(label: self, inRange: rangeOfString) {
                delegate?.tappableLabel(self, didTapLinkAtIndex: string.offset, withContent: string.element)
            }
        }
    }

    override func applyStyle() {
        super.applyStyle()

        for tappableString in tappableStrings {
            guard let attributedText = attributedText else {
                continue
            }
            let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)

            if let range = attributedText.string.range(of: tappableString) {
                let start = attributedText.string.distance(from: attributedText.string.startIndex,
                                                           to: range.lowerBound)
                let end = attributedText.string.distance(from: attributedText.string.startIndex,
                                                         to: range.upperBound)

                var attributes = StyleGuide.shared.style(row: tappableRow,
                                                         column: tappableColumn,
                                                         weight: tappableWeight)
                if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle, removeLinespacing {
                    let mutableParagraphStyle = NSMutableParagraphStyle()
                    mutableParagraphStyle.setParagraphStyle(paragraphStyle)
                    mutableParagraphStyle.lineSpacing = 0
                    attributes[.paragraphStyle] = mutableParagraphStyle
                }

                mutableAttributedText.setAttributes(attributes,
                                                    range: NSRange(location: start, length: end - start))
                self.attributedText = mutableAttributedText
            }
        }
    }

}
