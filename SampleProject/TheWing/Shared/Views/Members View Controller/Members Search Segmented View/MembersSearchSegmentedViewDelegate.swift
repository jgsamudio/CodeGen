//
//  MembersSearchSegmentedViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 8/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol MembersSearchSegmentedViewDelegate: class {
    
    /// Called when a segmented item is selected.
    ///
    /// - Parameter type: Member search category. (e.g. all, asks.. )
    func segmentedItemSelected(category: MemberSearchCategory)
    
}
