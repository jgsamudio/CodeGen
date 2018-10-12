//
//  ParkBenchTimer.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/9/18.
//

import Foundation

class ParkBenchTimer {

    // MARK: - Public Properties
    
    let startTime: CFAbsoluteTime
    var endTime: CFAbsoluteTime?

    var duration:CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
    
    // MARK: - Initialization
    
    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }

    // MARK: - Public Functions
    
    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        return duration!
    }

}
