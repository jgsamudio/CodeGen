//
//  UIImageExtension.swift
//  TheWing
//
//  Created by Luna An on 4/5/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

extension UIImage {
    
    // MARK: - Public Properties
    
    /// Returns image data if available.
    var imageData: Data? {
        return UIImageJPEGRepresentation(self, 1)
    }
    
    // MARK: - Public Functions
    
    /// Compares two images using their image data.
    ///
    /// - Parameter image: Image to compare to.
    /// - Returns: Flag if the two images are the same.
    func isEqualToImage(image: UIImage) -> Bool {
        guard let imageData = imageData, let anotherImageData =  image.imageData else {
            return false
        }
        
        return imageData == anotherImageData
    }
    
}
