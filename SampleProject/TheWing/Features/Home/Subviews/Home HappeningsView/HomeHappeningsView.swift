//
//  HomeHappeningsView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class HomeHappeningsView: BuildableView {

    // MARK: - Public Properties
    
    weak var delegate: HomeHappeningsDelegate?

    weak var eventViewDelegate: EventCellDelegate?

    weak var emptyHappeningsViewDelegate: EmptyMyHappeningsViewDelegate? {
        didSet {
            emptyHappeningsView.delegate = emptyHappeningsViewDelegate
        }
    }

    /// Total happenings count.
    var totalCount: Int? {
        didSet {
            configureHeader(totalCount: totalCount)
        }
    }

    // MARK: - Private Properties
    
    private lazy var headerView = SectionHeaderActionView(theme: theme)
    
    private lazy var eventsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var emptyHappeningsView = EmptyMyHappeningsView(theme: theme)

    private lazy var spacingView: UIView = {
        let view = UIView()
        stackViewHeightConstraint = view.autoSetDimension(.height, toSize: emptyHappeningsView.frame.height)
        view.isHidden = true
        return view
    }()

    private var stackViewHeightConstraint: NSLayoutConstraint?

    private var eventData = [EventData]()

    // MARK: - Constants

    fileprivate static let gutter: CGFloat = 24
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets up the happenings view.
    ///
    /// - Parameters:
    ///   - events: Events to display.
    ///   - totalCount: Total count of for the header.
    func setup(eventData: [EventData], totalCount: Int, isEmpty: Bool) {
        layoutIfNeeded()
        self.eventData = eventData
        self.totalCount = totalCount
        configureStackView()
        showEmptyState(show: isEmpty)
    }

    /// Updates the happenings view with the given parameters.
    ///
    /// - Parameters:
    ///   - eventData: Event data of the event to update.
    ///   - remove: Flag if the event should be removed.
    ///   - animated: Flag to animate the change.
    ///   - collapse: Flag to collapse after the event is removed.
    func updateMyHappening(eventData: EventData, remove: Bool, animated: Bool, collapse: Bool) {
        for subView in eventsStackView.arrangedSubviews {
            if let eventCellView = subView as? EventCellView, eventCellView.data?.eventId == eventData.eventId {
                eventCellView.setup(data: eventData)
                guard remove else {
                    return
                }
                removeEventCellView(eventCellView: eventCellView,
                                    eventData: eventData,
                                    animated: animated,
                                    collapse: collapse)

            }
        }
    }

    /// Adds an event to the list.
    ///
    /// - Parameter eventData: Event data of the event to add.
    func addMyHappening(eventData: EventData) {
        let eventCellView = addEventCellView(eventData: eventData)
        eventCellView.alpha = 0
        eventCellView.isHidden = true
        UIView.animate(withDuration: AnimationConstants.defaultDuration) {
            eventCellView.alpha = 1
            eventCellView.isHidden = false
        }
    }

}

// MARK: - Private Functions
private extension HomeHappeningsView {
    
    func setupView() {
        setupHeaderView()
        setupStackView()
        setupEmptyStateView()
    }
    
    func setupHeaderView() {
        addSubview(headerView)
        let insets = UIEdgeInsets(top: 28, left: HomeHappeningsView.gutter, bottom: 0, right: HomeHappeningsView.gutter)
        headerView.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
    }
    
    func setupStackView() {
        addSubview(eventsStackView)
        eventsStackView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        eventsStackView.autoPinEdge(.top, to: .bottom, of: headerView, withOffset: 12)
    }

    func setupEmptyStateView() {
        addSubview(emptyHappeningsView)
        emptyHappeningsView.autoPinEdge(.leading, to: .leading, of: self)
        emptyHappeningsView.autoPinEdge(.trailing, to: .trailing, of: self)
        emptyHappeningsView.autoPinEdge(.top, to: .bottom, of: headerView, withOffset: 12)
    }
    
    func configureStackView() {
        eventsStackView.removeAllArrangedSubviews()
        eventData.forEach {
            addEventCellView(eventData: $0)
        }
        eventsStackView.addArrangedSubview(spacingView)
    }

    @discardableResult func addEventCellView(eventData: EventData) -> EventCellView {
        let view = EventCellView(theme: theme, options: HomeEventCellViewOptions())
        view.delegate = eventViewDelegate
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(eventSelected)))
        view.backgroundColor = theme.colorTheme.invertPrimary
        view.setup(data: eventData)
        eventsStackView.addArrangedSubview(view)
        return view
    }

    func configureHeader(totalCount: Int?) {
        let title = HomeLocalization.navigationTitle(forType: .myHappenings, andHappeningsCount: totalCount)
        headerView.setup(title: title,
                         buttonTitle: HomeLocalization.myHappeningsHeaderSeeAllButtonTitle,
                         target: self,
                         selector: #selector(openAllAttendees))
        headerView.actionContainerHidden = (totalCount ?? 0) <= 3
    }
    
    @objc func openAllAttendees() {
        delegate?.seeAllEventsSelected()
    }

    @objc func eventSelected(gestureRecognizer: UIGestureRecognizer) {
        if let cellView = gestureRecognizer.view as? EventCellView, let eventData = cellView.data {
            delegate?.eventSelected(eventData: eventData)
        }
    }

    func updateHeaderTitle() {
        let emptyState = totalCount == 0
        let title = HomeLocalization.navigationTitle(forType: .myHappenings,
                                                     andHappeningsCount: emptyState ? nil : totalCount)
        headerView.updateSection(title: title, hideButton: emptyState)
    }

    func removeEventCellView(eventCellView: EventCellView, eventData: EventData, animated: Bool, collapse: Bool) {
        guard animated else {
            if collapse {
                eventCellView.removeFromSuperview()
            }
            delegate?.eventRemoved(eventData: eventData)
            return
        }

        eventCellView.isUserInteractionEnabled = false
        UIView.animate(withDuration: AnimationConstants.defaultDuration, delay: 0.6, options: .curveEaseOut, animations: {
            eventCellView.alpha = 0
            if collapse {
                eventCellView.isHidden = true
            }
        }) { [weak self] (_) in
            if collapse {
                eventCellView.removeFromSuperview()
            }
            self?.delegate?.eventRemoved(eventData: eventData)
            self?.updateHeaderTitle()
        }
    }

    func showEmptyState(show: Bool) {
        let title = HomeLocalization.navigationTitle(forType: .myHappenings, andHappeningsCount: show ? nil : totalCount)
        headerView.updateSection(title: title, hideButton: show)

        if show {
            emptyHappeningsView.alpha = show ? 0 : 1
            stackViewHeightConstraint?.constant = emptyHappeningsView.frame.height
            UIView.animate(withDuration: AnimationConstants.fastAnimationDuration) {
                self.emptyHappeningsView.alpha = show ? 1 : 0
                self.spacingView.isHidden = false
            }
        } else {
            emptyHappeningsView.alpha = 0
            spacingView.isHidden = true
        }
    }

}
