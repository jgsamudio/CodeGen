//
//  MainTabBarDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

protocol MainTabBarDelegate: class {

    /// Flag to determine if the status bar should be hidden.
    var statusBarHidden: Bool { get }

    /// Called when the drawer should be shown.
    func showDrawer()

    /// Retreives the profile image view with the given parameter.
    ///
    /// - Parameter completion: Completion block that returns the profile image.
    func getProfileImage(completion: @escaping ((UIImage?) -> Void))

}
