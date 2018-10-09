//
//  PickerViewRow.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/31/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// A row to display within a picker view component.
struct PickerViewRow: Equatable {

    /// Value displayed for `self`.
    let displayValue: String

    /// Action to take if this value is selected.
    let callback: () -> Void

}

func == (_ lhs: PickerViewRow, _ rhs: PickerViewRow) -> Bool {
    return lhs.displayValue == rhs.displayValue
}
