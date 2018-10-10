//
//  EditProfilePhotoViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 4/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Delegate functions for edit profile edit photo view.
protocol EditProfilePhotoViewDelegate: ImagePickerDelegate {
    
    /// Indicates that the edit photo has been selected.
    func editPhoto()
    
    /// Sets the new avatar image when a new photo is selected.
    ///
    /// - Parameter newAvatar: New avatar image.
    func setNewAvatar(newAvatar: UIImage)
    
}
