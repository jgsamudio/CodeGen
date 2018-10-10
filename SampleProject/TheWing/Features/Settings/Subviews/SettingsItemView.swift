//
//  SettingsItemView.swift
//  TheWing
//
//  Created by Luna An on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class SettingsItemView: BuildableView {
    
    // MARK: - Public Properties

    weak var delegate: SettingsItemViewDelegate?
        
    // MARK: - Private Properties
    
    private lazy var titleLabel = UILabel()
    
    private var switchType: SettingsSwitchType?
    
    private lazy var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch(frame: CGRect(origin: .zero, size: CGSize(width: 51, height: 31)))
        toggleSwitch.setOn(false, animated: true)
        toggleSwitch.isHidden = true
        toggleSwitch.addTarget(self, action: #selector(switchStateChanged), for: .touchUpInside)
        return toggleSwitch
    }()
    
    // MARK: - Constants
    
    private static var gutter: CGFloat = 20
    
    // MARK: - Initialization
    
    /// Creates an instance of double bordered image view.
    ///
    /// - Parameter theme: Theme.
    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    
    /// Sets up the view with title and switch component.
    ///
    /// - Parameters:
    ///   - title: Settings item title.
    ///   - hasSwitch: Flag if the item should have a switch.
    ///   - switchType: Settings switch type ( e.g. events, announcements )
    ///   - isOn: Indicates if the switch state is on or off.
    ///   - color: Custom color to override the default text color.
    func setup(title: String,
               hasSwitch: Bool,
               switchType: SettingsSwitchType? = nil,
               isOn: Bool = false,
               color: UIColor? = nil) {
        if let color = color {
            titleLabel.setText(title, using: textStyleTheme.bodyNormal.withColor(color))
        } else {
            titleLabel.setText(title, using: textStyleTheme.bodyNormal)
        }
        self.switchType = switchType
        toggleSwitch.isHidden = !hasSwitch
        toggleSwitch.isOn = isOn
    }

}

// MARK: - Private Functions
private extension SettingsItemView {
    
    func setupView() {
        backgroundColor = colorTheme.invertTertiary
        autoSetDimension(.height, toSize: 50)
        setupTitleLabel()
        setupToggleSwitch()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: SettingsItemView.gutter)
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: self)
    }
    
    private func setupToggleSwitch() {
        addSubview(toggleSwitch)
        toggleSwitch.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -SettingsItemView.gutter)
        toggleSwitch.autoAlignAxis(.horizontal, toSameAxisOf: self)
    }
    
    @objc func switchStateChanged() {
        delegate?.toggleNotifications(switchType: switchType, isOn: toggleSwitch.isOn)
    }
    
}
