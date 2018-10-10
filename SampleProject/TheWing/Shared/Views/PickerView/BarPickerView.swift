//
//  BarPickerView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Custom bar picker view with one component.
final class BarPickerView: BaseBarPickerView {

    // MARK: - Public Properties

    /// Bar picker view delegate.
    weak var delegate: BarPickerViewDelegate?

    /// Datasource of the picker view.
    var dataSource = [String]() {
        didSet {
            pickerView.reloadAllComponents()
        }
    }

    /// The selected index of the picker.
    var selectedIndex: Int {
        get {
            return pickerView.selectedRow(inComponent: 0)
        } set {
            pickerView.selectRow(newValue, inComponent: 0, animated: false)
        }
    }

    // MARK: - Public Functions

    /// Sets the first item in the picker.
    func setFirstItem() {
        if let firstItem = dataSource.first {
            selectedIndex = 0
            delegate?.didSelectItem(item: firstItem)
        }
    }
    
    // MARK: - Initialization

    override init(theme: Theme) {
        super.init(theme: theme)
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UIPickerViewDataSource
extension BarPickerView: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }

}

// MARK: - UIPickerViewDelegate
extension BarPickerView: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard dataSource.count > row else {
            return
        }
        
        delegate?.didSelectItem(item: dataSource[row])
    }

    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let labelComponent = view as? UILabel ?? UILabel()
        let color = theme.colorTheme.emphasisQuintary
        let textStyle = theme.textStyleTheme.headline3.withLineSpacing(0).withColor(color).withAlignment(.center)
        
        labelComponent.setText(dataSource[row], using: textStyle)
        return labelComponent
    }

}
