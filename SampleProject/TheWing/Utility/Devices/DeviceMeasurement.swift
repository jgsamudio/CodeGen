//
//  DeviceMeasurement.swift
//  TheWing
//
//  Created by Luna An on 3/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

struct DeviceMeasurement {
    
    // MARK: - Public Functions
    
    /// Returns a value measured for varying device sizes.
    ///
    /// - Parameters:
    ///   - smallDevices: Value for small devices. (i.g. iPhone 5S, iPhone SE)
    ///   - regularDevices: Value for regular devices. (i.g. iPhone 6, iPhone 6S, iPhone 7, iPhone 8)
    ///   - largeDevices: Value for larger devices.
    ///     (i.g. iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus, iPhone 8 Plus, iPhone X)
    /// - Returns: CGFloat.
    static func value(smallDevices: CGFloat = 0,
                      regularDevices: CGFloat = 0,
                      largeDevices: CGFloat = 0) -> CGFloat {
    
    // MARK: - Public Properties
    
        let value: CGFloat
        
        if UIScreen.isLarge {
            value = largeDevices
        } else if UIScreen.isSmall {
            value = smallDevices
        } else {
            value = regularDevices
        }
        
        return value
    }
    
}
