//
//  SettingsItemTableViewCell.swift
//  TheWing
//
//  Created by Luna An on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class SettingsItemTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties

    /// Settings item view delegate.
    weak var delegate: SettingsItemViewDelegate?
    
    // MARK: - Private Properties
    
    private var settingsItemView: SettingsItemView?
    
    // MARK: - Public Functions
  
    /// Sets settings item cell view.
    ///
    /// - Parameters:
    ///   - theme: Theme.
    ///   - title: Title of the settings item.
    ///   - hasSwitch: Flag to determine if the item includes a switch component.
    ///   - switchType: Settings switch type ( e.g. events, announcements )
    ///   - isOn: Indicates if the switch state is on or off.
    ///   - color: Custom color to override the default text color.
    func setup(theme: Theme,
               title: String,
               hasSwitch: Bool,
               switchType: SettingsSwitchType?,
               isOn: Bool,
               color: UIColor? = nil) {
        setupCellView(theme: theme, hasSwitch: hasSwitch)
        settingsItemView?.setup(title: title, hasSwitch: hasSwitch, switchType: switchType, isOn: isOn, color: color)
    }

}

// MARK: - Private Functions
private extension SettingsItemTableViewCell {
    
    func setupCellView(theme: Theme, hasSwitch: Bool) {
        guard self.settingsItemView?.superview == nil else {
            return
        }
        backgroundColor = UIColor.clear
        selectionStyle = .none
        let settingsItemView = SettingsItemView(theme: theme)
        addSubview(settingsItemView)
        settingsItemView.autoPinEdgesToSuperviewEdges()
        self.settingsItemView = settingsItemView
        if hasSwitch {
            self.settingsItemView?.delegate = delegate
        }
    }
    
}
