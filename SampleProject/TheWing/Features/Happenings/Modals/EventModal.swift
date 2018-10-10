//
//  EventModal.swift
//  TheWing
//
//  Created by Luna An on 5/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import MessageUI

final class EventModal: BuildableView {
    
    // MARK: - Public Properties
    
    /// The type of this event modal.
    var type: EventModalType
    
    // MARK: - Private Properties
    
    private var eventModalData: EventModalData?
    
    private weak var delegate: BaseModalCardDelegate?
    
    private weak var addToCalendarViewDelegate: AddToCalendarViewDelegate?
    
    private var modalDescriptionView: ModalDescriptionView?
    
    private var eventWithFeeView: EventWithFeeView?
    
    private var eventCalendarContainerView: EventCalendarContainerView?
    
    private lazy var containerView = UIView()
    
    private lazy var bottomModalView: BottomModalView = {
        let bottomModalView = BottomModalView(theme: theme, type: type)
        return bottomModalView
    }()
    
    private lazy var cardView: ModalCardView = {
        return ModalCardView(view: containerView, style: type.modalCardStyle, theme: theme)
    }()
    
    private lazy var baseCardView: BaseModalCardView = {
        let baseCardView = BaseModalCardView(theme: theme,
                                             modal: self,
                                             cardView: cardView,
                                             bottomModalView: bottomModalView,
                                             topImage: type.topIcon,
                                             bottomImage: type.bottomIcon)
        baseCardView.set(title: type.title)
        baseCardView.delegate = delegate
        addSubview(baseCardView)
        return baseCardView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.autoSetDimensions(to: CGSize(width: 190, height: EventModal.buttonViewHeight))
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var buttonContainerView: UIView = {
        let containerView = UIView()
        containerView.autoSetDimension(.height, toSize: EventModal.buttonViewHeight)
        addSubview(containerView)
        return containerView
    }()
    
    private lazy var cancelButton = StylizedButton(buttonStyle: theme.buttonStyleTheme.floatingTextDarkButtonStyle)
    private lazy var confirmButton = StylizedButton(buttonStyle: theme.buttonStyleTheme.secondaryFiveButtonStyle)
    private lazy var joinWaitlistButton = StylizedButton(buttonStyle: theme.buttonStyleTheme.secondaryThreeButtonStyle)

    // MARK: - Constants
    
    private static let verticalGutter: CGFloat = 30
    private static let buttonViewHeight: CGFloat = 96
    
    // MARK: - Initialization
    
    init(theme: Theme,
         type: EventModalType,
         delegate: BaseModalCardDelegate? = nil,
         calendarViewDelegate: AddToCalendarViewDelegate? = nil) {
        self.type = type
        self.delegate = delegate
        self.addToCalendarViewDelegate = calendarViewDelegate
        super.init(theme: theme)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Sets up view with event data.
    ///
    /// - Parameter eventData: Event modal data to use.
    func setup(eventData: EventModalData) {
        self.eventModalData = eventData
        eventCalendarContainerView?.removeFromSuperview()
        eventWithFeeView?.removeFromSuperview()
        modalDescriptionView?.removeFromSuperview()
        setupView()
    }
    
}

// MARK: - Private Functions
private extension EventModal {
    
    func setupView() {
        guard let data = eventModalData else {
            return
        }
        autoSetDimension(.width, toSize: UIScreen.width - ViewConstants.defaultGutter * 2)
        setupBaseCardView(eventData: data)
        setupBottomModalView()
    }
    
    func setupBaseCardView(eventData: EventModalData) {
        switch type {
        case .feeExplanation:
            setupFeeExplanationDescriptionView()
        case .upgradeMembership:
            setupUpgradeMembershipDescriptionView()
        case .rsvpWithFee, .waitlistWithFee:
            setupEventWithFeeView()
        default:
            setupEventView(eventData: eventData)
        }
        
        let insets = UIEdgeInsets(top: EventModal.verticalGutter, left: 0, bottom: EventModal.verticalGutter, right: 0)
        baseCardView.autoPinEdgesToSuperviewEdges(with: insets)
    }
    
    func setupFeeExplanationDescriptionView() {
        guard let description = type.description,
            let feeString = eventModalData?.eventData.feeString else {
            return
        }
        
        let text = String(format: description, feeString)
        setupDescriptionView(with: text)
    }
    
    func setupUpgradeMembershipDescriptionView() {
        guard let description = type.description,
            let location = eventModalData?.eventData.locationName else {
                return
        }
        
        let text = String(format: description, location)
        setupDescriptionView(with: text)
    }
        
    func setupDescriptionView(with text: String) {
        modalDescriptionView = ModalDescriptionView(theme: theme)
        modalDescriptionView?.set(description: text)
        setupContainerView(view: modalDescriptionView)
    }
    
    func setupEventView(eventData: EventModalData) {
        guard let eventData = eventModalData?.eventData else {
            return
        }
        eventCalendarContainerView = EventCalendarContainerView(theme: theme,
                                                                eventData: eventData,
                                                                delegate: addToCalendarViewDelegate,
                                                                modalType: type)
        setupContainerView(view: eventCalendarContainerView)
    }
    
    func setupEventWithFeeView() {
        guard let title = eventModalData?.eventData.title,
            let fee = eventModalData?.eventData.feeString else {
                return
        }
        
        eventWithFeeView = EventWithFeeView(theme: theme)
        eventWithFeeView?.set(title: title, fee: fee)
        setupContainerView(view: eventWithFeeView)
    }
    
    func setupContainerView(view: UIView?) {
        guard let view = view else {
            return
        }
        containerView.backgroundColor = theme.colorTheme.invertPrimary
        containerView.addSubview(view)
        view.autoPinEdgesToSuperviewEdges()
    }
    
    func setupBottomModalView() {
        bottomModalView.translatesAutoresizingMaskIntoConstraints = false
        switch type {
        case .rsvp:
            setupRSVPBottom()
        case .cancelRSVP, .cancelWaitlist:
            setupCancellationBottom()
        case .waitlist:
            bottomModalView.setup(description: type.bottomModalDescription)
        case .upgradeMembership:
            setupUpgradeMembershipBottom()
        case .feeExplanation:
            bottomModalView.setup(description: type.bottomModalDescription)
        case .rsvpWithFee:
            setupRSVPWithFeeBottom()
        case .waitlistWithFee:
            setupWaitlistWithFeeBottom()
        }
    }
    
    func setupRSVPBottom() {
        let button = StylizedButton(buttonStyle: theme.buttonStyleTheme.tertiaryButtonStyle)
        button.autoSetDimensions(to: ViewConstants.defaultCTAButtonSize)
        let addGuestsText = "ADD_GUESTS_TITLE".localized(comment: "Add Guests")
        button.setTitle(addGuestsText.uppercased(), for: .normal)
        button.accessibilityLabel = addGuestsText
        button.addTarget(self, action: #selector(addGuestSelected), for: .touchUpInside)
        
        guard let data = eventModalData else {
            return
        }
        
        if data.guestRegistrationOpen {
            bottomModalView.setup(icon: #imageLiteral(resourceName: "guests_icon"), description: type.bottomModalDescription, button: button)
        } else {
            bottomModalView.setupEmptyView()
        }
    }
    
    func setupCancellationBottom() {
        let button = StylizedButton(buttonStyle: theme.buttonStyleTheme.secondaryFourButtonStyle)
        button.autoSetDimensions(to: CGSize(width: 247, height: ViewConstants.defaultButtonHeight))
        let title = "CONFIRM_CANCELLATION_TITLE".localized(comment: "Confirm Cancellation").uppercased()
        button.setTitle(title, for: .normal)
        if type == .cancelRSVP {
            button.addTarget(self, action: #selector(cancelRSVPSelected), for: .touchUpInside)
        } else if type == .cancelWaitlist {
            button.addTarget(self, action: #selector(cancelWaitlistSelected), for: .touchUpInside)
        }
        bottomModalView.setup(description: type.bottomModalDescription, button: button)
    }
            
    func setupRSVPErrorBottom() {
        joinWaitlistButton.autoSetDimensions(to: CGSize(width: 190, height: ViewConstants.defaultButtonHeight))
        let title = "JOIN_WAITLIST_TITLE".localized(comment: "Join Waitlist").uppercased()
        joinWaitlistButton.setTitle(title, for: .normal)
        joinWaitlistButton.addTarget(self, action: #selector(waitlistSelected), for: .touchUpInside)
        bottomModalView.setup(description: type.bottomModalDescription, button: joinWaitlistButton)
    }
    
    func setupUpgradeMembershipBottom() {
        let button = StylizedButton(buttonStyle: theme.buttonStyleTheme.tertiaryButtonStyle)
        button.autoSetDimensions(to: ViewConstants.defaultCTAButtonSize)
        let title = "CONTACT_US".localized(comment: "Contact Us").uppercased()
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(contactUsSelected), for: .touchUpInside)
        bottomModalView.setup(icon: #imageLiteral(resourceName: "add_person_icon"), description: type.bottomModalDescription, button: button)
    }
    
    func setupRSVPWithFeeBottom() {
        setupCancelButtonOnEventWithFeeModal()
        let confirmButtonTitle = "CONFIRM_RSVP_TITLE".localized(comment: "Confirm RSVP").uppercased()
        confirmButton.setTitle(confirmButtonTitle, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmRSVPSelected), for: .touchUpInside)
        buttonStackView.addArrangedSubview(confirmButton)
        buttonStackView.addArrangedSubview(cancelButton)
        setupButtonStackView()
        setupFeeDescription()
    }
    
    func setupWaitlistWithFeeBottom() {
        setupCancelButtonOnEventWithFeeModal()
        let joinWaitlistButtonTitle = "JOIN_WAITLIST_TITLE".localized(comment: "Join Waitlist").uppercased()
        joinWaitlistButton.setTitle(joinWaitlistButtonTitle, for: .normal)
        joinWaitlistButton.addTarget(self, action: #selector(joinWaitlistSelected), for: .touchUpInside)
        buttonStackView.addArrangedSubview(joinWaitlistButton)
        buttonStackView.addArrangedSubview(cancelButton)
        setupButtonStackView()
        setupFeeDescription()
    }
    
    private func setupCancelButtonOnEventWithFeeModal() {
        buttonStackView.removeAllArrangedSubviews()
        let cancelButtonTitle = "NO_THANKS_TITLE".localized(comment: "No, thanks").uppercased()
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelActionSelected), for: .touchUpInside)
    }
    
    private func setupButtonStackView() {
        buttonContainerView.addSubview(buttonStackView)
        buttonStackView.autoCenterInSuperview()
    }
    
    private func setupFeeDescription() {
        if let fee = eventModalData?.eventData.feeString, fee.isValidString {
            let feeDescription = String(format: type.bottomModalDescription, fee)
            bottomModalView.setup(description: feeDescription, buttonView: buttonContainerView)
        }
    }
    
    @objc func addGuestSelected() {
        guard let eventData = eventModalData?.eventData else {
            return
        }
        delegate?.addGuestSelected(eventData: eventData)
    }
    
    @objc func cancelRSVPSelected() {
        delegate?.cancelRSVPSelected()
    }
    
    @objc func cancelWaitlistSelected() {
        delegate?.cancelWaitlistSelected()
    }
    
    @objc func waitlistSelected() {
        delegate?.waitlistSelected()
    }
    
    @objc func contactUsSelected() {
        delegate?.composeMailSelected()
    }
    
    @objc func cancelActionSelected() {
        delegate?.cancelSelected()
    }
    
    @objc func confirmRSVPSelected() {
        delegate?.confirmRSVPSelected()
    }
    
    @objc func joinWaitlistSelected() {
        delegate?.joinWaitlistSelected()
    }

}
