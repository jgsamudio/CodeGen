//
//  FilterButton.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class FilterButton: UIButton {
    
    // MARK: - Private Properties
    
    private let theme: Theme
    
    // MARK: - Initialization
    
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets the title of the button given a count value.
    ///
    /// - Parameter count: Count.
    func setFilterCount(_ count: Int) {
    
    // MARK: - Public Properties
    
        let textColor = theme.colorTheme.emphasisQuintary
        let textStyle = theme.textStyleTheme.bodySmall.withColor(textColor).withMinLineHeight(13)
        let filterText = count > 0 ? String(format: "FILTER_COUNT".localized(comment: "Filter (n)"), "\(count)") :
            "FILTER".localized(comment: "Filter")
        let filterImage = count > 0 ? nil : #imageLiteral(resourceName: "filter_button")
        setMarkdownTitleText("**\(filterText)**", using: textStyle)
        setImage(filterImage, for: .normal)
        titleEdgeInsets = count > 0 ? .zero : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        imageEdgeInsets = count > 0 ? .zero : UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }
    
}

// MARK: - Private Functions
private extension FilterButton {
    
    func setupButton() {
        backgroundColor = theme.colorTheme.emphasisTertiary
        semanticContentAttribute = .forceRightToLeft
        autoSetDimensions(to: CGSize(width: 95, height: 34))
        setupBorder()
    }
    
    func setupBorder() {
        layer.borderColor = theme.colorTheme.tertiary.cgColor
        layer.borderWidth = 1
    }
    
}
