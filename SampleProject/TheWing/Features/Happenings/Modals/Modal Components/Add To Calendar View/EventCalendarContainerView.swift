//
//  EventCalendarContainerView.swift
//  TheWing
//
//  Created by Luna An on 5/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import UIKit

final class EventCalendarContainerView: BuildableView {
    
    // MARK: - Private Properties
    
    private weak var delegate: AddToCalendarViewDelegate?
    
    private var eventData: EventData
    
    private lazy var eventView = UIView()
    
    private lazy var addToCalendarView = AddToCalendarView(theme: theme, delegate: delegate)
    
    private lazy var stackView: UIStackView = {
    
    // MARK: - Public Properties
    
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Initialization
    
    init(theme: Theme,
         eventData: EventData,
         delegate: AddToCalendarViewDelegate? = nil,
         modalType: EventModalType) {
        self.eventData = eventData
        self.delegate = delegate
        super.init(theme: theme)
        setupView(modalType: modalType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Functions
private extension EventCalendarContainerView {
    
    func setupView(modalType: EventModalType) {
        backgroundColor = theme.colorTheme.invertPrimary
        setupContainerView(modalType: modalType)
    }
    
    private func setupContainerView(modalType: EventModalType) {
        addSubview(stackView)
        stackView.removeAllArrangedSubviews()
        setupEventView(modalType: modalType)
        
        if modalType.canAddToCalendar {
           stackView.addArrangedSubview(addToCalendarView)
        }

        NSLayoutConstraint.autoSetPriority(.defaultHigh) {
            stackView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
            stackView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -6)
        }
        
    }
    
    private func setupEventView(modalType: EventModalType) {
        let eventCellView = EventCellView(theme: theme, options: ModalEventCellViewOptions())
        eventCellView.setup(data: eventData, modalType: modalType)
        eventCellView.hideSeperatorView()
        eventCellView.hideHeadlineView()
        eventView = eventCellView
        stackView.addArrangedSubview(eventView)
    }
    
}
