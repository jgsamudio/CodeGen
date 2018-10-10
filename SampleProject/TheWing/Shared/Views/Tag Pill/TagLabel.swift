//
//  TagLabel.swift
//  TheWing
//
//  Created by Luna An on 4/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Tag label used in the tag pill view.
final class TagLabel: UILabel {
    
    // MARK: - Private Properties
    
    private var insets = UIEdgeInsets(top: 0, left: 1, bottom: 3, right: 0)
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }

    // MARK: - Public Properties

    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += insets.top + insets.bottom
        intrinsicSuperViewContentSize.width += insets.left + insets.right
        return intrinsicSuperViewContentSize
    }
    
}

// MARK: - Private Functions
private extension TagLabel {
    
    private func setup() {
        textAlignment = .center
        numberOfLines = 1
        sizeToFit()
    }
    
}
