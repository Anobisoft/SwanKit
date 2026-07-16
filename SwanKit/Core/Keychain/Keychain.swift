//
//  Keychain.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import Foundation

/// A thread-safe, high-performance cryptography namespace providing an abstraction layer over Apple's Security Keychain services.
public struct Keychain: Sendable {

    /// An isolated configuration profile container representing a specific Keychain Service domain identity.
    ///
    /// `Service` encapsulates sub-routing credentials (such as service identifier strings and access groups),
    /// exposing safe asynchronous mutators to look up, write, list, or erase secure passwords.
    ///
    /// ### Swift 6 Concurrency Semantics
    /// Structurally immutable and fully conforms to `Sendable`. Safe for concurrent task cross-isolation context access.
    public struct Service: Sendable {

        /// The primary service identifier token bound to this domain sub-routing environment (maps onto `kSecAttrService`).
        public let id: String

        /// An optional shared access group identifier utilized for App Sandbox Keychain Sharing credentials exchange (maps onto `kSecAttrAccessGroup`).
        public let accessGroup: String?

        /// Initializes a discrete secure service environment context configuration layout profile.
        ///
        /// - Parameters:
        ///   - id: The primary service domain identifier string token.
        ///   - accessGroup: An optional target Keychain Access Group string descriptor context for cross-app token sharing.
        public init(id: String, accessGroup: String? = nil) {
            self.id = id
            self.accessGroup = accessGroup
        }
    }
}
