//
//  UserLoader.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire

final class NetworkProfileLoader: Loader, ProfileLoader {

    // MARK: - Public Functions
    
    func updateProfile(fields: [String: Any], completion: @escaping (_ result: Result<User>) -> Void) {
    
    // MARK: - Public Properties
    
        let request = apiRequest(method: .patch, endpoint: Endpoints.updateProfile, parameters: fields)
        httpClient.perform(request: request) { (result: Result<User>) in
            if result.isSuccess {
                self.sessionManager.user = result.value
            }
            completion(result)
        }
    }
    
    func update(profile: EditableProfile, completion: @escaping (_ result: Result<User>) -> Void) {
        let request = apiRequest(method: .patch, endpoint: Endpoints.updateProfile, parameters: profile.parameters)

        httpClient.perform(request: request) { (result: Result<User>) in
            if result.isSuccess {
                self.sessionManager.user = result.value
            }
            completion(result)
        }
    }

    func loadIndustries(completion: @escaping (_ result: Result<[Industry]>) -> Void) {
        let request = apiRequest(method: .get, endpoint: Endpoints.industries, parameters: nil)
        httpClient.perform(request: request, completion: completion)
    }

    func upload(avatar: Data, result: @escaping ([String: Any]?) -> Void, errors: ((Error?) -> Void)? = nil) {
        guard let userId = sessionManager.user?.userId else {
            return
        }
        
        var headers: Headers = ["Content-Type": "multipart/form-data"]
        if let token = sessionManager.authToken {
            headers["x-access-token"] = token
        }
        
        guard let endpoint = endpointUrl(path: Endpoints.updateAvatar(userId: userId)) else {
            return
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(avatar, withName: "avatar_image", fileName: "file.jpg", mimeType: "image/jpeg")
        }, usingThreshold: UInt64(), to: endpoint, method: .put, headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let responseJson = response.value as? [String: Any] {
                        result(responseJson)
                    } else {
                        errors?(response.error)
                    }
                }
            case .failure(let error):
                errors?(error)
            }
        }
    }

}
