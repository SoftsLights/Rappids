//
// Created by Jascha MERLE on 07/08/2023.
//

import Foundation

/// Represents errors related to size validation.
///
/// The `SizeError` enum is used to indicate errors that can occur during the validation
/// of size values in your application. It conforms to the `Error` protocol, allowing you
/// to throw and catch these errors in a structured way.
enum SizeError: Error {

    /// Indicates that the provided size string is invalid.
    ///
    /// This size string is invalid because it could not be parsed from the provided string.
    case invalidSizeString
}
