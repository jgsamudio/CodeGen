//
//  BarDatePickerViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 7/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol BarDatePickerViewDelegate: class {
    
    /// Called when a month is selected in the picker view.
    ///
    /// - Parameter month: Month selected.
    func didSelectMonth(at month: Int)
    
    /// Called when a day is selected in the picker view.
    ///
    /// - Parameter day: Day selected.
    func didSelectDay(at dayIndex: Int)
    
}

