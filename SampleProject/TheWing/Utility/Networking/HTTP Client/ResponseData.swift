//
//  ResponseData.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/*
Default response for a data response.
Example:
 {
 "data": {
     "events": [
         {
            // Decodable object.
         }
    ]
 },
 "meta": {
     "pagination": {
         "total": 3465,
         "offset": 0,
         "page": 1,
         "hitsPerPage": 20
     }
 }
 */
struct ResponseData<T: Decodable>: Decodable {

    // MARK: - Public Properties
    
    /// Decodable data object.
    let data: T

    /// Optional meta data.
    let meta: Meta?

}
