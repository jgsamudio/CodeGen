//
//  EventDetailButtonView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EventDetailButtonView: BuildableView {
    
    // MARK: - Public Properties
    
    var statusTypes = [EventActionButtonSource]() {
        didSet {
            updateButtons(oldStatusTypes: oldValue)
        }
    }
    
    weak var delegate: EventDetailButtonDelegate?
    
    // MARK: - Private Properties
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var lockedButton: LockedButton = {
        let view = LockedButton(theme: theme)
        addSubview(view)
        view.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        view.autoSetDimension(.height, toSize: ViewConstants.bottomButtonHeight)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lockedButtonSelected)))
        return view
    }()
    
    private var typeButtonDataSource = [StylizedButton: EventActionButtonSource]()
    
    // MARK: - Initialization
    
    init(theme: Theme, delegate: EventDetailButtonDelegate? = nil) {
        self.delegate = delegate
        super.init(theme: theme)
        setupView()
    }
    
    // MARK: - Public Functions
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews.reversed() {
            let convertedPoint = subview.convert(point, from: self)
            if let view = subview.hitTest(convertedPoint, with: event) {
                return view
            }
        }
        
        return super.hitTest(point, with: event)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Updates the button loading status.
    ///
    /// - Parameters:
    ///   - loading: Flag to determine if the button is loading.
    ///   - type: Type of the button to load.
    func isLoading(loading: Bool, type: EventActionButtonSource) {
        for (button, statusType) in typeButtonDataSource {
            if type.typeId == statusType.typeId {
                button.isLoading(loading: loading)
                return
            }
        }
    }
    
}

// MARK: - Private Functions
private extension EventDetailButtonView {
    
    func setupView() {
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges()
    }
    
    func updateButtons(oldStatusTypes: [EventActionButtonSource]) {
        guard (statusTypes.map { $0.typeId }) == (oldStatusTypes.map { $0.typeId }) else {
            updateStackView()
            return
        }

        stackView.subviews.forEach {
            if let button = $0 as? StylizedButton,
                let typeIndex = statusTypes.index(where: { $0.typeId == typeButtonDataSource[button]?.typeId }),
                statusTypes[typeIndex].buttonTitle != typeButtonDataSource[button]?.buttonTitle {
                typeButtonDataSource[button] = statusTypes[typeIndex]
                typeButtonDataSource[button]?.updateButtonStyle(button: button, buttonStyleTheme: theme.buttonStyleTheme)
            }
        }
    }
    
    func updateStackView() {
        isAccessibilityElement = false
        stackView.removeAllArrangedSubviews()
        statusTypes.forEach {
            guard $0.typeId != EventActionButtonSource.locked.typeId else {
                addSubview(lockedButton)
                isAccessibilityElement = true
                accessibilityTraits = UIAccessibilityTraitButton
                accessibilityLabel = $0.smallButtonTitle
                return
            }
            
            lockedButton.removeFromSuperview()

            if let button = $0.button(buttonStyleTheme: theme.buttonStyleTheme) {
                button.addTarget(self, action: #selector(styleButtonSelected(button:)), for: .touchUpInside)
                typeButtonDataSource[button] = $0
                stackView.addArrangedSubview(button)
            }
        }
    }
    
    @objc func styleButtonSelected(button: StylizedButton) {
        guard let status = typeButtonDataSource[button] else {
            return
        }
        delegate?.buttonSelected(status: status)
    }
    
    @objc func lockedButtonSelected() {
        delegate?.buttonSelected(status: .locked)
    }
    
}
