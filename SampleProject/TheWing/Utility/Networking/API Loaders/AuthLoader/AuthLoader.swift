//
//  AuthLoader.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire

protocol AuthLoader {
    
    /// Sign In a user with the given parameters.
    ///
    /// - Parameters:
    ///   - email: Email of the user.
    ///   - password: Password of the user.
    ///   - completion: Completion handler with a deserialized user.
    func signIn(email: String, password: String, completion: @escaping (_ result: Result<User>) -> Void)

    /// Gets a user object with the given parameters.
    ///
    /// - Parameters:
    ///   - authToken: auth token of the user.
    ///   - completion: Completion handler with a deserialized user.
    func user(authToken: String, completion: @escaping (_ result: Result<User>) -> Void)

    /// Gets current user object.
    ///
    /// - Parameter completion: Completion handler with a deserialized user.
    func user(completion: @escaping (_ result: Result<User>) -> Void)
    
}
