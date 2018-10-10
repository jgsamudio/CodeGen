//
//  BarDatePickerView.swift
//  TheWing
//
//  Created by Luna An on 7/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Custom date picker view with two components.
final class BarDatePickerView: BaseBarPickerView {
    
    // MARK: - Public Properties
    
    /// Bar date picker view delegate.
    weak var delegate: BarDatePickerViewDelegate?
    
    /// Datasource for months.
    var monthsDataSource = [String]() {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    /// Datasource for days.
    var daysDataSource = [String]() {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    /// Selected month.
    var selectedMonth: Int {
        get {
            return pickerView.selectedRow(inComponent: 0)
        } set {
            pickerView.selectRow(newValue, inComponent: 0, animated: false)
        }
    }
    
    /// Selected day.
    var selectedDay: Int {
        get {
            return pickerView.selectedRow(inComponent: 1)
        } set {
            pickerView.selectRow(newValue, inComponent: 1, animated: false)
        }
    }
    
    // MARK: - Public Functions
    
    /// Sets the first item on the picker view.
    func setFirstItem() {
        selectedMonth = 1
        selectedDay = 1
        delegate?.didSelectMonth(at: selectedMonth)
        delegate?.didSelectDay(at: selectedDay)
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
extension BarDatePickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? monthsDataSource.count : daysDataSource.count
    }
    
}

// MARK: - UIPickerViewDelegate
extension BarDatePickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            let monthIndex = monthsDataSource.index(of: monthsDataSource[row]) ?? 0
            daysDataSource = ["-"] + Date.days(for: monthIndex).map {String($0)}
            selectedMonth = row
            delegate?.didSelectMonth(at: row)
        case 1:
            selectedDay = row
            delegate?.didSelectDay(at: row)
        default:
            return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let labelComponent = view as? UILabel ?? UILabel()
        let color = theme.colorTheme.emphasisQuintary
        let textStyle = theme.textStyleTheme.headline3.withLineSpacing(0).withColor(color).withAlignment(.center)
        
        let text = component == 0 ? monthsDataSource[row] : daysDataSource[row]
        labelComponent.setText(text, using: textStyle)
 
        return labelComponent
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }

}
