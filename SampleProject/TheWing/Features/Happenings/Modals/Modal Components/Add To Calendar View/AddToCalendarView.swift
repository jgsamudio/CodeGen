//
//  AddToCalendarView.swift
//  TheWing
//
//  Created by Luna An on 5/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class AddToCalendarView: BuildableView {
    
    // MARK: - Public Properties
    
    weak var delegate: AddToCalendarViewDelegate?
    
    // MARK: - Private Properties
    
    private lazy var topBorderView: UIView = {
        let borderView = UIView.dividerView(height: 1,
                                            color: theme.colorTheme.emphasisQuaternary.withAlphaComponent(0.2))
        addSubview(borderView)
        return borderView
    }()
    
    private lazy var calendarIconImageView: UIImageView = {
        let calendarIconView = UIImageView(image: #imageLiteral(resourceName: "add_to_calendar"))
        calendarIconView.contentMode = .scaleAspectFit
        calendarIconView.isAccessibilityElement = false
        return calendarIconView
    }()
    
    private lazy var addToCalendarLabel: UILabel = {
        let addToCalendarLabel = UILabel()
        
        let text = "ADD_TO_CALENDAR_TEXT".localized(comment: "Add to calendar")
        let textStyle = theme.textStyleTheme.captionBig.withColor(theme.colorTheme.emphasisPrimary)
        addToCalendarLabel.isAccessibilityElement = false
        addToCalendarLabel.setMarkdownText("*\(text.uppercased())*", using: textStyle)
        return addToCalendarLabel
    }()
    
    private lazy var containerView: UIView = {
        let containerview = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(addToCalendarSelected))
        containerview.addGestureRecognizer(tap)
        addSubview(containerview)
        return containerview
    }()

    // MARK: - Constants
    
    private static let offset: CGFloat = 56
    
    // MARK: - Initialization
    
    init(theme: Theme, delegate: AddToCalendarViewDelegate? = nil) {
        self.delegate = delegate
        super.init(theme: theme)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Functions
private extension AddToCalendarView {
    
    func setupView() {
        backgroundColor = .clear
        autoSetDimension(.height, toSize: 51)
        setupTopBorder()
        setupContainerView()
        isAccessibilityElement = true
        accessibilityLabel = "ADD_TO_CALENDAR_TEXT".localized(comment: "Add to calendar")
        accessibilityTraits = UIAccessibilityTraitButton
    }
    
    func setupTopBorder() {
        let insets = UIEdgeInsets(top: 0, left: AddToCalendarView.offset, bottom: 0, right: AddToCalendarView.offset)
        topBorderView.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
    }
    
    func setupContainerView() {
        containerView.addSubview(calendarIconImageView)
        containerView.addSubview(addToCalendarLabel)
        
        calendarIconImageView.autoPinEdge(.top, to: .top, of: containerView)
        calendarIconImageView.autoPinEdge(.leading, to: .leading, of: containerView)
        
        let offset: CGFloat = 13
        addToCalendarLabel.autoAlignAxis(.horizontal, toSameAxisOf: calendarIconImageView)
        addToCalendarLabel.autoPinEdge(.leading, to: .trailing, of: calendarIconImageView, withOffset: offset)

        let insets = UIEdgeInsets(top: offset, left: AddToCalendarView.offset, bottom: 17, right: AddToCalendarView.offset)
        containerView.autoPinEdgesToSuperviewEdges(with: insets)
    }
    
    @objc func addToCalendarSelected() {
        delegate?.addToCalendarSelected()
    }
    
}
