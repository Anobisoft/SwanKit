//
//  Keychain.Query.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import Foundation

extension Keychain {

    /// A convenient alias for dictionaries wrapping generic Apple Security query attributes.
    typealias QueryData = Dictionary<String, AnyObject>
}

extension Dictionary {

    /// Bridges the Swift `Dictionary` representation natively into a low-level CoreFoundation `CFDictionary`.
    var CF: CFDictionary {
        self as CFDictionary
    }
}

extension Keychain.QueryData {

    /// Sets the standard Security data layout class attribute inside the query container.
    /// - Parameter secClass: The target cryptographic data class wrapper strategy.
    mutating func setSecClass(_ secClass: Keychain.SecClass) {
        self[kSecClass] = secClass.rawValue
    }

    /// Accesses or modifies generic metadata object references using native `CFString` keys.
    subscript(key: CFString) -> AnyObject? {
        get { self[key as String] }
        set {
            guard newValue != nil else { return }
            self[key as String] = newValue
        }
    }

    /// Accesses or modifies strongly-typed `String` attribute records using native `CFString` keys.
    subscript(key: CFString) -> String? {
        get { self[key as String] as? String }
        set {
            guard newValue != nil else { return }
            self[key as String] = newValue as AnyObject
        }
    }

    /// Accesses or modifies unencrypted binary `Data` buffer payloads using native `CFString` keys.
    subscript(key: CFString) -> Data? {
        get { self[key as String] as? Data }
        set {
            guard newValue != nil else { return }
            self[key as String] = newValue as AnyObject
        }
    }

    /// Accesses or modifies boolean configuration state flags (bridged via `kCFBooleanTrue` / `kCFBooleanFalse`).
    subscript(key: CFString) -> Bool {
        get { CFBooleanCast(self[key as String]) }
        set { self[key as String] = (newValue ? kCFBooleanTrue : kCFBooleanFalse) as AnyObject }
    }

    /// Safely unwraps an opaque reference type block into a standard Swift `Bool`, validating its low-level CoreFoundation type identifier.
    ///
    /// - Parameter value: The raw untyped object pointer extracted from the dictionary payload.
    /// - Returns: `true` if the underlying object is a valid `CFBoolean` equal to true; otherwise, `false`.
    func CFBooleanCast(_ value: AnyObject?) -> Bool {
        guard
            let value,
            CFGetTypeID(value) == CFBooleanGetTypeID()
        else { return false }
        return CFBooleanGetValue(.some(value as! CFBoolean))
    }
}
