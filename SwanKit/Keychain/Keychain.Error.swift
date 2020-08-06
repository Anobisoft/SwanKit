//
//  Keychain.Error.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2020-08-04.
//  Copyright © 2020 Anobisoft. All rights reserved.
//

import Foundation

extension OSStatus: Error {}

extension Keychain {
    public enum Error: Swift.Error {
        case genericPasswordParsingError
        case passwordEncodingError
    }
}
