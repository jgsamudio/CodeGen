//
//  OnboardingButtonsViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 7/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol OnboardingButtonsViewDelegate: class {
    
    /// Indicates the back button is selected.
    func backButtonSelected()
    
    /// Indicates the next button is selected.
    func nextButtonSelected()
    
}
