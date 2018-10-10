//
//  EventTableViewCell.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EventTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    private var eventCellView: EventCellView?

    // MARK: - Public Functions

    override func prepareForReuse() {
        super.prepareForReuse()
        eventCellView?.cancelImageRequest()
    }
    
    /// Sets up the table view cell.
    ///
    /// - Parameters:
    ///   - theme: Application theme.
    ///   - data: Data to pass to the event cell view.
    ///   - isLoading: Boolean indicating whether the view is loading or not.
    ///   - delegate: Event cell delegate.
    ///   - options: Cell view options.
    func setup(theme: Theme,
               data: EventCellData?,
               isLoading: Bool,
               delegate: EventCellDelegate?,
               options: EventCellViewOptions) {
        backgroundColor = theme.colorTheme.invertPrimary
        selectionStyle = .none
        setupCellView(theme: theme)
        eventCellView?.setup(data: data,
                             options: options,
                             isLoading: isLoading)
        eventCellView?.delegate = delegate
    }

}

// MARK: - Private Functions
private extension EventTableViewCell {

    func setupCellView(theme: Theme) {
        guard self.eventCellView?.superview == nil else {
            return
        }
        
    // MARK: - Public Properties
    
        let eventCellView = EventCellView(theme: theme, options: ListEventCellViewOptions())
        contentView.addSubview(eventCellView)
        NSLayoutConstraint.autoSetPriority(.defaultHigh) {
            eventCellView.autoPinEdgesToSuperviewEdges()
        }
        self.eventCellView = eventCellView
    }

}
