//
//  SearchTagsDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/// Tags delegate.
protocol SearchTagsDelegate: class {
    
    /// Adds a new tag to collection of tags.
    ///
    /// - Parameters:
    ///   - newTag: New tag.
    ///   - type: Type of tag.
    func add(tag: String, type: ProfileTagType)
    
}
