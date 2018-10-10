//
//  HomeAnalyticsProvider.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class HomeAnalyticsProvider: HomeAnalyticsDelegate {
    
    // MARK: - Private Properties

    private let dependencyProvider: DependencyProvider
    
    private var analyticsProvider: AnalyticsProvider {
        return dependencyProvider.analyticsProvider
    }
    
    // MARK: - Initialization

    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions

    func trackTaskViewed(data: TaskData, at index: Int) {
        analyticsProvider.track(event: AnalyticsHomeConstants.Events.taskViewed,
                                properties: taskProperties(for: data, at: index),
                                options: nil)
    }
    
    func trackTaskCTAClicked(data: TaskData, at index: Int) {
        analyticsProvider.track(event: AnalyticsHomeConstants.Events.taskCTAClicked,
                                properties: taskProperties(for: data, at: index),
                                options: nil)
    }
    
}

// MARK: - Private Functions
private extension HomeAnalyticsProvider {
    
    func taskProperties(for task: TaskData, at index: Int) -> [String: Any] {
        return [AnalyticsConstants.platformKey: AnalyticsConstants.iOS,
                AnalyticsHomeConstants.Keys.cardId: task.identifier,
                AnalyticsHomeConstants.Keys.cardTitle: task.title,
                AnalyticsHomeConstants.Keys.buttonAction: task.actionType.rawValue,
                AnalyticsHomeConstants.Keys.cardCTA: task.buttonTitle,
                AnalyticsHomeConstants.Keys.cardNumber: "\(index+1)"]
    }
    
}
