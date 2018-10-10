//
//  ProfileHeaderConfigurable.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileHeaderConfigurable {

    /// Sets the profile image of the tab bar item header view.
    ///
    /// - Parameter profileImage: Image to set.
    func set(profileImage: UIImage)

}
