//
//  DependencyProvider.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol DependencyProvider {

    /// Network provider of the dependency provider.
    var networkProvider: LoaderProvider { get }
    
    /// Analytics provider of the dependency provider.
    var analyticsProvider: AnalyticsProvider { get }
    
}

