//
//  TextFieldPicker.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class TextFieldPicker {

    // MARK: - Public Properties

    /// Texst field picker delegate.
    weak var delegate: TextFieldPickerDelegate?

    /// Picker field view.
    let fieldView: PickerFieldView
    
    /// Bottom transition view controller.
    let transitioner: BottomTransitionViewContainer
    
    /// Bar pikcer view used to display items in one column.
    var pickerView: BarPickerView?
    
    /// Date picker view used to display months and days in two columns.
    var datePickerView: BarDatePickerView?
    
    // MARK: - Private Properties

    private var currentItem: String?
    private var currentDate: (month: Int?, day: Int?)

    // MARK: - Initialization

    init(fieldView: PickerFieldView,
         pickerView: BarPickerView? = nil,
         datePickerView: BarDatePickerView? = nil,
         transitioner: BottomTransitionViewContainer) {
        self.fieldView = fieldView
        self.pickerView = pickerView
        self.datePickerView = datePickerView
        self.transitioner = transitioner

        self.fieldView.delegate = self
        self.pickerView?.delegate = self
        self.pickerView?.baseDelegate = self
        self.datePickerView?.delegate = self
        self.datePickerView?.baseDelegate = self
    }

    // MARK: - Public Functions

    /// Hides the picker view.
    func hidePickerView() {
        fieldView.updateArrow(pickerVisible: false)
        transitioner.hide()
    }

    /// Displays the items and updates the necessary views to present the data.
    ///
    /// - Parameters:
    ///   - items: Items to present.
    ///   - selectedIndex: Selected index to set the selected item.
    func display(items: [String], selectedIndex: Int?) {
        pickerView?.dataSource = items
        pickerView?.selectedIndex = selectedIndex ?? 0

        if let selectedIndex = selectedIndex {
            currentItem = items[selectedIndex]
            fieldView.set(text: items[selectedIndex])
        }
    }
    
    /// Displays the date items and updates the necessary views to present the birthday data.
    ///
    /// - Parameters:
    ///   - months: Months items to present.
    ///   - days: Days items to present.
    ///   - selectedDate: Selected date.
    func display(months: [String], days: [String], selectedDate: Birthday?) {
        datePickerView?.monthsDataSource = months
        datePickerView?.daysDataSource = days
        
        let month = selectedDate?.month ?? 0
        let day = selectedDate?.day ?? 0
        
        datePickerView?.selectedMonth = month
        datePickerView?.selectedDay = day
        
        currentDate.month = month
        currentDate.day = day
        
        if selectedDate != nil {
            if month == 0 || day == 0 {
                fieldView.set(text: "--")
            } else {
                fieldView.set(text: "\(months[month]) \(days[day])")
            }
        }
    }

}

// MARK: - BaseBarPickerViewDelegate
extension TextFieldPicker: BaseBarPickerViewDelegate {
    
    func didSelectDone() {
        fieldView.updateArrow(pickerVisible: false)
        transitioner.hide()
        delegate?.didSelectDone(textFieldPicker: self)
    }
    
}

// MARK: - BarPickerViewDelegate
extension TextFieldPicker: BarPickerViewDelegate {

    func didSelectItem(item: String) {
        currentItem = item
        delegate?.didSelectPickerItem(item: item, textFieldPicker: self)
    }

}

// MARK: - BarDatePickerViewDelegate
extension TextFieldPicker: BarDatePickerViewDelegate {

    func didSelectMonth(at month: Int) {
        currentDate.month = month
        currentDate.day = min((currentDate.day ?? 0), Date.days(for: month).count)
        delegate?.didSelectPickerItems(firstItem: month,
                                       secondItem: month == 0 ? 0 : currentDate.day ?? 0,
                                       textFieldPicker: self)
    }
    
    func didSelectDay(at day: Int) {
        currentDate.day = day
        delegate?.didSelectPickerItems(firstItem: currentDate.month ?? 0,
                                       secondItem: day,
                                       textFieldPicker: self)
    }
    
}

// MARK: - PickerFieldDelegate
extension TextFieldPicker: PickerFieldDelegate {

    func didSelectField() {
        transitioner.toggle()
        fieldView.updateArrow(pickerVisible: transitioner.isVisible)
        delegate?.didSelectField(textFieldPicker: self)

        if currentItem == nil {
            pickerView?.setFirstItem()
        }
        
        if currentDate.month == nil, currentDate.day == nil {
            datePickerView?.setFirstItem()
        }
    }

}
