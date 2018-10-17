//
//  DataDecoder.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation
import Alamofire

/// Decodes data from a network response.
///
/// **Subspec: Utility/HTTPClient**
///
/// ```
/// Alamofire.request(request.endpoint).responseJSON { (response) in
///     completion(self.decoder.decodeData(response.data))
/// }
/// ```
///
/// The data decoder can be used with network requests that return a Data object. The DataDecoder uses the APIErrorType to
/// identify the network errors. If the object can not be deserialized the decoder will print out which coding key failed the
/// the deserialization. Integration with the killswitch is also available if the api error received matched the unique
/// killswitch or force update identifier.
///
open class DataDecoder {
    
    // MARK: - Private Properties
    
    /// JSON Decoder used to decode the object.
    private let decoder: JSONDecoder

    // MARK: - Initialization

    /// Default initializer.
    ///
    /// - Parameters:
    ///   - decoder: JSON Decoder to decode objects with.
    ///   - killSwitchProvider: Optional KillSwitchProvider.
    public init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    // MARK: - Public Functions

    /// Decodes the data into the desired result.
    ///
    /// - Parameter data: Data to deserialize.
    /// - Returns: Desired result with the deserialized object.
    public func decodeData<T: Decodable>(_ data: Data?) -> Result<T> {
        guard let data = data else {
            return Result.failure(APIErrorType.noDataRetreived)
        }

        do {
            let model = try decoder.decode(T.self, from: data)
            return Result.success(model)
        } catch {
            return decodeError(data, decodeError: error)
        }
    }

}

// MARK: - Private Functions
private extension DataDecoder {

    /// Decodes the error if the decoder was unable to decode the object type requested.
    ///
    /// - Parameters:
    ///   - data: Data of the request.
    ///   - decodeError: Optional error from the json decoder.
    /// - Returns: The failed result of the request.
    func decodeError<T: Decodable>(_ data: Data, decodeError: Error) -> Result<T> {
        #if DEBUG
        print("Deserialization Failed: ")
        print(decodeError)
        #endif
        return Result.failure(APIErrorType.deserializationFailed)

    }

}
