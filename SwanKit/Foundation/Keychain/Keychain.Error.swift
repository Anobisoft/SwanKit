//
//  Keychain.Error.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import Foundation

/// A retroactive conformance bridge allowing native system status codes to be thrown as structured Swift errors.
extension OSStatus: @retroactive Swift.Error {}

extension Keychain {

    /// Specific cryptography errors thrown during processing pipelines inside the framework's Keychain module layer.
    public enum Error: Swift.Error {

        /// Indicates that raw data bytes extracted from the Security database failed format parsing or textual string layout translation loops.
        case genericPasswordParsingError

        /// Indicates that the plain-text password string layout failed character conversion transformations required for binary encoding.
        case passwordEncodingError
    }
}
