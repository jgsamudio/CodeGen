//
//  UIImageViewExtension.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

extension UIImageView {
    
    // MARK: - Initialization
    
    /// Convience init with content mode
    ///
    /// - Parameters:
    ///   - image: The image you want
    ///   - contentMode: The content mode you want
    convenience init(image: UIImage?, contentMode: UIViewContentMode = .scaleToFill) {
        self.init(image: image)
        self.contentMode = contentMode
    }
    
    // MARK: - Public Functions
    
    /// Loads image from an URL.
    ///
    /// - Parameters:
    ///   - url: Image URL.
    ///   - completion: Completion handler.
    func loadImage(from url: URL, completion: ((Bool) -> Void)? = nil) {
    
    // MARK: - Public Properties
    
        let cachedImage = AlamoFireImageLoader.loadImageFromCache(for: url)
        guard cachedImage == nil else {
            image = cachedImage
            completion?(true)
            return
        }
        
        af_setImage(withURL: url) { (result) in
            if let image = result.value {
                AlamoFireImageLoader.cacheImage(image, url: url)
                completion?(true)
            } else {
                completion?(false)
            }
        }
    }
    
}
