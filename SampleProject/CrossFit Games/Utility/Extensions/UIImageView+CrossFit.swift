//
//  UIImageView+CrossFit.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/18/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

extension UIImageView {

    /// Downloads for specified imageURL. If imageURL is nil, a placeholder image will be set.
    ///
    /// - Parameter imageURL: URL to fetch and update image view with
    func download(imageURL: URL?) {
        let placeholderImage = UIImage.image(with: UIColor(displayP3Red: 248/255, green: 248/255, blue: 248/255, alpha: 1))
        guard let imageURL = imageURL else {
            image = placeholderImage
            return
        }
        
        af_setImage(withURL: imageURL,
                    placeholderImage: placeholderImage,
                    imageTransition: .crossDissolve(0.2))
    }
    
}
