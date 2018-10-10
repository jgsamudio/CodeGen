//
//  TagPillView.swift
//  TheWing
//
//  Created by Luna An on 3/29/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Custom pill shaped view.
final class TagPillView: UIView {
    
    // MARK: - Private Properties
    
    private var theme: Theme
    private var isRemovable: Bool = false
    private var isSelectable: Bool = false
    private var selected: Bool = false
    
    private lazy var addImage: UIImageView = {
    
    // MARK: - Public Properties
    
        let imageView = UIImageView(image: #imageLiteral(resourceName: "plus"))
        imageView.contentMode = .scaleAspectFit
        imageView.autoSetDimension(.width, toSize: 14)
        return imageView
    }()
    
    private lazy var tagLabel = TagLabel()
    
    private lazy var checkImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "checkmark"))
        imageView.contentMode = .scaleAspectFit
        imageView.autoSetDimension(.width, toSize: 14)
        return imageView
    }()
    
    private lazy var closeImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "close"))
        imageView.contentMode = .scaleAspectFit
        imageView.autoSetDimension(.width, toSize: 14)
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 12
        return stackView
    }()

    // MARK: - Initialization
    
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: .zero)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets the tag with a corresponding background color.
    ///
    /// - Parameters:
    ///   - tag: The title.
    ///   - backgroundColor: The background color.
    ///   - isRemovable: Boolean value indiciating if the tag is removable.
    ///   - isSelectable: Boolean value indiciating if the tag is selectable.
    ///   - selected: Boolean value indicating if the tag was selected.
    func set(tag: String,
             backgroundColor: UIColor,
             isRemovable: Bool = false,
             isSelectable: Bool = false,
             selected: Bool = false) {
        let textStyle = theme.textStyleTheme.subheadlineLarge.withAlignment(.center)
        let textColor = selected ? theme.colorTheme.invertTertiary : theme.colorTheme.emphasisQuaternary
        tagLabel.setText(truncatedText(original: tag), using: textStyle.withColor(textColor))
        
        self.backgroundColor = backgroundColor
        self.isRemovable = isRemovable
        self.isSelectable = isSelectable
        self.selected = selected
        
        setupStackView()
    }
    
}

// MARK: - Private Functions
private extension TagPillView {
    
    func setupDesign() {
        layer.cornerRadius = 18
        layer.borderWidth = 1
        layer.borderColor = theme.colorTheme.primary.withAlphaComponent(0.2).cgColor
        autoPinField()
    }
    
    func setupStackView() {
        if stackView.superview == nil {
            addSubview(stackView)
        }
        stackView.removeAllArrangedSubviews()

        // isRemovable := close image appears right of tag label
        // isSelectable := plus image appears left of tag label
        // selected := check image appears left of tag label
        switch (isRemovable, isSelectable, selected) {
        case (true, false, false):
            stackView.addArrangedSubview(tagLabel)
            stackView.addArrangedSubview(closeImage)
        case (false, true, false):
            stackView.addArrangedSubview(addImage)
            stackView.addArrangedSubview(tagLabel)
        case (false, false, true):
            stackView.addArrangedSubview(checkImage)
            stackView.addArrangedSubview(tagLabel)
        default:
            stackView.addArrangedSubview(tagLabel)
        }
    }
    
    func autoPinField() {
        addSubview(stackView)
        NSLayoutConstraint.autoSetPriority(.defaultHigh) {
            stackView.autoSetDimension(.height, toSize: 22)
        }

        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15))
    }
    
    func truncatedText(original text: String) -> String {
        guard text.count > 30 else {
            return text
        }

        return text.prefix(27) + "..."
    }
    
}
