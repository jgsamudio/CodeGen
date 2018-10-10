//
//  DateLocationInfoViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 5/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol DateLocationInfoViewDelegate: AddToCalendarViewDelegate {
    
    /// Called when the address is selected.
    func addressSelected()
    
}
