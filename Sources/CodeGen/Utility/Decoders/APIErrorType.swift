//
//  APIErrorType.swift
//  AST
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

/// Enum for the possible API errors.
///
/// **Subspec: Utility/APIError**
///
/// ```
/// func decodeData<T: Decodable>(_ data: Data?) -> Result<T> {
///     guard let data = data else {
///         return Result.failure(APIErrorType.noDataRetreived)
///     }
///
///     do {
///         let model = try decoder.decode(T.self, from: data)
///         return Result.success(model)
///     } catch {
///         return decodeError(data, decodeError: error)
///     }
/// }
/// ```
///
/// When decoding the objects from an API errors can be identified with the APIErrorType. In the example above the
/// APIErrorType is used to identify when no data is returned from the API. The other options allows for identifying failed
/// deserializations and custom error codes through the APIError model.
///
/// - noDataRetreived: Used when the data is nil from the api.
/// - deserializationFailed: Used when the data can't be deserialized into the desired model.
public enum APIErrorType: Error {
    case noDataRetreived
    case deserializationFailed

    // MARK: - Public Properties
    
    /// Localized description.
    public var localizedDescription: String {
        switch self {
        case .noDataRetreived:
            return "No Data Retrieved"
        case .deserializationFailed:
            return "Deserialization Failed"
        }
    }

}
