//
//  EventDetailButtonDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EventDetailButtonDelegate: class {

    /// Called when the button is selected in the buttomn view.
    ///
    /// - Parameter status: Type of the button selected.
    func buttonSelected(status: EventActionButtonSource)
    
}
