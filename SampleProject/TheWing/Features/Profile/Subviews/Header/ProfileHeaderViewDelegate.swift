//
//  ProfileHeaderViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Delegate functions for profile header view.
protocol ProfileHeaderViewDelegate: class {
    
    /// Visit URL delegate.
    ///
    /// - Parameter socialLink: Social link to visit.
    func visit(_ socialLink: SocialLink)
    
}
