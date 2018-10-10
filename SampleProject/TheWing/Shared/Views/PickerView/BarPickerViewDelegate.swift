//
//  BarPickerViewDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol BarPickerViewDelegate: class {

    /// Called when an item is selected in the picker view.
    ///
    /// - Parameter item: Item selected.
    func didSelectItem(item: String)

}
