//
//  URLExtension.swift
//  TheWing
//
//  Created by Jonathan Samudio on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension URL {

    // MARK: - Initialization
    
    /// Initializes a url with the given email.
    ///
    /// - Parameter email: Email to mail to.
    init?(email: String) {
        self.init(string: "mailto:\(email)")
    }

}
