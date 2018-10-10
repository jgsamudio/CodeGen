//
//  HomeLoader.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire

protocol HomeLoader {

    /// Sends post request to acknowledge a to do.
    ///
    /// - Parameters:
    ///   - identifier: Path to acknowledge to do.
    ///   - completion: Completion block containing success value. 
    func acknowledgeTask(identifier: String, completion: @escaping (_ result: Result<ResponseData<Acknowledge>>) -> Void)
    
    /// Loads the home api call with the given parameters.
    ///
    /// - Parameters:
    ///   - eventsLimit: Number of max events to load.
    ///   - postLimit: Number of max posts to load.
    ///   - completion: Complete block of the network call.
    func loadHome(eventsLimit: Int, postLimit: Int, completion: @escaping (_ result: Result<Home>) -> Void)

}
