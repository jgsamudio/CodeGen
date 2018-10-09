//
//  FileError.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/2/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

enum FileError: Error {
    case writeError(description: String?)
    case readError(description: String?)
}
