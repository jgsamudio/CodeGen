//
//  UIImage+CrossFit.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/18/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

extension UIImage {
    
    // MARK: - Public Functions
    
    /// Creates a UIImage for the specified color.
    /// Primary usage: Placeholders for loading screens
    /// - Parameter tintColor: UIColor to utilize to fill image with
    /// - Returns: UIImage
    static func image(with tintColor: UIColor) -> UIImage {
    
    // MARK: - Public Properties
    
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
