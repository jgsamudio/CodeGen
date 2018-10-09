//
//  UIStoryboard+CrossFit.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/20/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

extension UIStoryboard {

    // MARK: - Public Functions
    
    /// Creates a view controller of the given type. The view controller's storyboard identifier has to be equal
    /// to its class name or otherwise, this will cause a fatal error.
    ///
    /// - Returns: View controller of the expected type.
    func instantiateViewController<T: UIViewController>() -> T {
    
    // MARK: - Public Properties
    
        let identifier = String(describing: T.self)
        guard let result = instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("""
                Wasn't able to find a view controller of type \(T.self) that also has identifier \(identifier)
                """)
        }

        return result
    }

}
