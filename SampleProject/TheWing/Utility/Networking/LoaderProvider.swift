//
//  LoaderProvider.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/25/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol LoaderProvider {
    
    /// Member API loader.
    var membersLoader: CommunityLoader { get set }
    
    /// Event API loader.
    var eventsLoader: EventsLoader { get set }
    
    /// Authentication API loader.
    var authLoader: AuthLoader { get set }
    
    /// User API loader.
    var userLoader: ProfileLoader { get set }
    
    /// Search results API loader.
    var searchResultsLoader: SearchResultsLoader { get set }
    
    /// Session manager.
    var sessionManager: SessionManager { get }

    /// Home loader.
    var homeLoader: HomeLoader { get }

    /// Local cache for events.
    var eventLocalCache: EventLocalCache { get }

}
