//
//  AlamoFireImageLoader.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/29/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire
import AlamofireImage

struct AlamoFireImageLoader {
    
    // MARK: - Public Properties
    
    static let imageCache = AutoPurgingImageCache()

    // MARK: - Public Functions
    
    static func cacheImage(_ image: UIImage?, url: URL) {
        guard let image = image else {
            return
        }
        
        AlamoFireImageLoader.imageCache.add(image, withIdentifier: url.absoluteString)
    }
    
    static func loadImageFromCache(for url: URL) -> UIImage? {
        return AlamoFireImageLoader.imageCache.image(withIdentifier: url.absoluteString)
    }
    
    static func loadImage(url: URL, completion: @escaping ((UIImage?) -> Void)) {
        let cachedImage = AlamoFireImageLoader.loadImageFromCache(for: url)
        guard cachedImage == nil else {
            completion(cachedImage)
            return
        }

        Alamofire.request(url).responseImage { (response) in
            guard let image = response.result.value else {
                completion(nil)
                return
            }

            completion(image)
            AlamoFireImageLoader.cacheImage(image, url: url)
        }
    }
    
}
