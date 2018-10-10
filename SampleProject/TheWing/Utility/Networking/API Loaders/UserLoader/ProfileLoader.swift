//
//  ProfileLoader.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/25/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire

protocol ProfileLoader {
    
    /// Updates the current user's profile for the specific field.
    ///
    /// - Parameters:
    ///   - fields: Profile fields to update.
    ///   - completion: Completion block of the network call.
    func updateProfile(fields: [String: Any], completion: @escaping (_ result: Result<User>) -> Void)
    
    /// Updates the current user with the given parameters.
    ///
    /// - Parameters:
    ///   - profile: Editable profile to update the current user to.
    ///   - completion: Completion block of the network call.
    func update(profile: EditableProfile, completion: @escaping (_ result: Result<User>) -> Void)
    
    /// Loads the available industries.
    ///
    /// - Parameter completion: Completion block of the network call.
    func loadIndustries(completion: @escaping (_ result: Result<[Industry]>) -> Void)
    
    /// Updates the current user profile image with the given parameters.
    ///
    /// - Parameters:
    ///   - avatar: Avatar data to upload.
    ///   - result: Result received from the server.
    ///   - errors: Errors received from the server.
    func upload(avatar: Data, result: @escaping ([String: Any]?) -> Void, errors: ((Error?) -> Void)?)
    
}
