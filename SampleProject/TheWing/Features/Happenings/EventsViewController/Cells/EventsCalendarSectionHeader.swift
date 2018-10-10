//
//  EventsCalendarSectionHeader.swift
//  TheWing
//
//  Created by Luna An on 4/22/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EventsCalendarSectionHeader: UITableViewHeaderFooterView {
    
    // MARK: - Private Properties
    
    private lazy var dateLabel = UILabel()

    private var shimmerView: UIView?

    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dateLabel)
        dateLabel.autoAlignAxis(.horizontal, toSameAxisOf: self)
        dateLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: 54)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets up the view with the given parameters.
    ///
    /// - Parameters:
    ///   - theme: Application theme.
    ///   - date: Date components to set the text of the label.
    ///   - isLoading: Flag to determine if the view is loading.
    func setup(theme: Theme, date: DateComponents?, isLoading: Bool) {
        contentView.backgroundColor = theme.colorTheme.secondary
        updateLoadingShimmerView(theme: theme, isLoading: isLoading)
        if let date = date {
            configureLabels(theme: theme, date: date)
        } else {
            dateLabel.text = ""
        }
    }
    
}

// MARK: - Private Functions
private extension EventsCalendarSectionHeader {
    
    func configureLabels(theme: Theme, date: DateComponents) {
        guard let date = Calendar.current.date(from: date) else {
            return
        }
        
    // MARK: - Public Properties
    
        let dayNameText = DateFormatter.dateString(from: date, format: DateFormatConstants.weekdayFormat)
        let dateText = DateFormatter.dateString(from: date, format: DateFormatConstants.shortDateFormat)
    
        let textStyle = theme.textStyleTheme.bodyLarge.withColor(theme.colorTheme.primary)
        let text = "**\(dayNameText.uppercased() + ViewConstants.dot)** \(dateText.uppercased())"
        dateLabel.setMarkdownText(text, using: textStyle)
    }

    func updateLoadingShimmerView(theme: Theme, isLoading: Bool) {
        if let shimmerView = shimmerView {
            if !isLoading {
                shimmerView.removeFromSuperview()
                self.shimmerView = nil
            }
        } else if isLoading {
            let backgroundColor = theme.colorTheme.emphasisQuaternary.withAlphaComponent(0.1)
            let view = ShimmerContainer.generateShimmerView(backgroundColor: backgroundColor)
            contentView.addSubview(view)
            view.autoAlignAxis(.horizontal, toSameAxisOf: self)
            view.autoPinEdge(.leading, to: .leading, of: self, withOffset: 54)
            view.autoSetDimensions(to: CGSize(width: 116, height: 13))
            shimmerView = view
        }
    }

}
