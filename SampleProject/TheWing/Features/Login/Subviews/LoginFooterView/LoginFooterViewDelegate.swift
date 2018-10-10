//
//  LoginFooterViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 3/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

protocol LoginFooterViewDelegate: class {
    
    /// Indicates user tapped the privacy policy button.
    func privacyPolicySelected()
    
    /// Indicates user tapped the terms and conditions button.
    func termsAndConditionsSelected()
    
}
