//
// Created by Jascha MERLE on 07/08/2023.
//

import Foundation

/// Represents errors related to thickness validation.
///
/// The `ThicknessError` enum is used to indicate errors that can occur during the validation
/// of thickness values in your application.
enum ThicknessError: Error {

    /// Indicates that the provided thickness is invalid.
    ///
    /// This thickness is invalid because it could not be parsed from the provided string.
    case invalidThicknessString
}

