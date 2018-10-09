//
//  PickerViewComponent.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/31/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Component to add to a picker view controller.
struct PickerViewComponent {

    /// Values to display in the picker.
    let displayValues: [PickerViewRow]

    /// Row that is initially selected (defaults to first row if not set).
    let selectedRow: PickerViewRow?

}
